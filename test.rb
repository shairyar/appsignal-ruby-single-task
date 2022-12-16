require 'appsignal'

Appsignal.config = Appsignal::Config.new(
  File.expand_path('../', __FILE__),          # Application root path
  'development',                              # Application environment
  :name => 'single-task',
  :log_path => 'logs',
  :log_level => 'trace'                       # Optional configuration hash
)


Appsignal.start_logger
Appsignal.start

at_exit do
  Appsignal.stop
  sleep 5
end

class OffSiteBackupInstrumentation
  # Omitted
  def export_stats
    Appsignal.increment_counter('off_site_backup.count', 1)
    Appsignal.set_gauge('off_site_backup.snapshot_count', 1)
    Appsignal.set_gauge('off_site_backup.total_size', 1)
  end
end

Appsignal.monitor_transaction('perform_job.off_site_backup', class: 'OffSiteBackupInstrumentation', method: 'export_stats', metadata: { postgres_database: "DB URL GOES HERE" }) do
  OffSiteBackupInstrumentation.new.export_stats
end