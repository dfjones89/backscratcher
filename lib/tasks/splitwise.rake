require 'benchmark'

namespace :splitwise do
  desc "Sync expenses with Splitwise"
  task sync: :environment do
    log("Starting Splitwise expense sync")
    benchmark = Benchmark.measure { Expense.sync_with_splitwise! }
    log("Splitwise expense sync completed in #{benchmark.real.round(2)} seconds")
  end
end

private

def log(message)
  puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}: #{message}"
end
