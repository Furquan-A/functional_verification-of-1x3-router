class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)

  // TLM FIFOs fed by monitors (wired in env.connect_phase)
  uvm_tlm_analysis_fifo #(router_wr_xtns) fifo_wrh;
  uvm_tlm_analysis_fifo #(router_rd_xtns) fifo_rdh[];

  // Per-destination expected queues (from write side)
  router_wr_xtns exp_q[][$];

  // Scratch
  router_wr_xtns wr_data;
  env_config     e_cfg;
  int            data_verified_count;

  // -------- Functional coverage --------
  // Sample with (addr, payload_len)
  covergroup router_fcov with function sample(bit [1:0] addr, int unsigned plen);
    option.per_instance = 1;

    ADDRESS : coverpoint addr {
      bins low  = {2'b00};
      bins mid1 = {2'b01};
      bins mid2 = {2'b10};
      // add 2'b11 later if you ever enable it
    }

    PAYLOAD_SIZE : coverpoint plen {
      bins small_packets  = {[1:13]};
      bins medium_packets = {[14:30]};
      bins large_packets  = {[31:63]};
    }

    ADDRESS_X_PAYLOAD_SIZE : cross ADDRESS, PAYLOAD_SIZE;
  endgroup

  router_fcov wr_cov;  // write-side
  router_fcov rd_cov;  // read-side

  function new(string name="router_scoreboard", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(env_config)::get(this,"","env_config", e_cfg))
      `uvm_fatal("CONFIG","cannot get env_config")

    wr_cov = new();
    rd_cov = new();

    fifo_wrh = uvm_tlm_analysis_fifo#(router_wr_xtns)::type_id::create("fifo_wrh", this);

    fifo_rdh = new[e_cfg.no_of_rd_agents];
    foreach (fifo_rdh[i]) begin
      fifo_rdh[i] = uvm_tlm_analysis_fifo#(router_rd_xtns)::type_id::create($sformatf("fifo_rdh[%0d]", i), this);
    end

    // one expected queue per read port
    exp_q = new[e_cfg.no_of_rd_agents];
  endfunction

  task run_phase(uvm_phase phase);
    // --- Write consumer: push to per-dest expected queues
    fork
      begin : WR_CONS
        forever begin
          fifo_wrh.get(wr_data);
          int unsigned dest = wr_data.header[1:0];
          int unsigned plen = wr_data.header[7:2];

          if (dest >= exp_q.size()) begin
            `uvm_error("SB", $sformatf("Write dest %0d out of range (size %0d)", dest, exp_q.size()))
          end
          else begin
            exp_q[dest].push_back(wr_data);
            `uvm_info("WRITE_SB", $sformatf("Enqueued EXP for dest %0d (plen=%0d)", dest, plen), UVM_LOW)
            wr_cov.sample(dest, plen);
          end
        end
      end

      // --- One read consumer per port: pop & compare
      begin : RD_CONS_ALL
        fork
          foreach (fifo_rdh[i]) begin
            automatic int idx = i;
            begin : RD_CONS
              forever begin
                router_rd_xtns rd_item;
                fifo_rdh[idx].get(rd_item);

                `uvm_info("READ_SB", $sformatf("Got RD from port %0d (plen=%0d)", idx, rd_item.header[7:2]), UVM_LOW)

                // Coverage on read
                rd_cov.sample(rd_item.header[1:0], rd_item.header[7:2]);

                // Match against expected from this port
                if (exp_q[idx].size() == 0) begin
                  `uvm_error("SB", $sformatf("No expected item queued for port %0d", idx))
                end
                else begin
                  router_wr_xtns exp = exp_q[idx].pop_front();
                  compare_items(idx, exp, rd_item);
                end
              end
            end
          end
        join_none
      end
    join
  endtask

  // ---------- Comparison ----------
  function void compare_items(int port, router_wr_xtns exp, router_rd_xtns got);
    string tag = $sformatf("SB[P%0d]", port);

    // Header
    if (exp.header !== got.header)
      `uvm_error(tag, $sformatf("HEADER mismatch exp=%0h got=%0h", exp.header, got.header))
    else
      `uvm_info(tag, "Header match", UVM_LOW)

    // Payload
    if (exp.payload_data.size() != got.payload_data.size()) begin
      `uvm_error(tag, $sformatf("PAYLOAD size mismatch exp=%0d got=%0d",
                                exp.payload_data.size(), got.payload_data.size()))
    end
    else begin
      bit ok = 1;
      foreach (exp.payload_data[i]) begin
        if (exp.payload_data[i] !== got.payload_data[i]) begin
          ok = 0;
          `uvm_error(tag, $sformatf("PAYLOAD[%0d] mismatch exp=%0h got=%0h",
                                    i, exp.payload_data[i], got.payload_data[i]))
        end
      end
      if (ok) `uvm_info(tag, "Payload match", UVM_LOW)
    end

    // Parity
    if (exp.parity !== got.parity)
      `uvm_error(tag, $sformatf("PARITY mismatch exp=%0h got=%0h", exp.parity, got.parity))
    else
      `uvm_info(tag, "Parity match", UVM_LOW)

    data_verified_count++;
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SB", $sformatf("Verified transactions: %0d", data_verified_count), UVM_LOW)
    `uvm_info("SB", $sformatf("Write cov  : %0.2f%%", wr_cov.get_coverage()), UVM_LOW)
    `uvm_info("SB", $sformatf("Read  cov  : %0.2f%%", rd_cov.get_coverage()), UVM_LOW)
  endfunction
endclass
