module PumaWorkerKiller
  class RollingRestart
    def initialize(master = nil)
      @cluster = PumaWorkerKiller::PumaMemory.new(master)
    end

    # used for tes
    def get_total_memory
      @cluster.get_total_memory
    end

    def reap(wait_between_worker_kill = 60) # seconds
      return false unless @cluster.running?
      @cluster.workers.each do |worker, ram|
        @cluster.master.log "PumaWorkerKiller: Rolling Restart. #{@cluster.workers.count} workers, total: #{ get_total_memory } mb. Sending TERM to pid #{worker.pid} (#{ram} mb)."
        worker.term
        return true # only kill 1 worker, the one with highest memory usage
        #sleep wait_between_worker_kill
      end
    end
  end
end
