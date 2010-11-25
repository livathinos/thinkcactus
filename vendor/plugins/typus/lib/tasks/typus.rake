namespace :typus do

  desc "List current roles."
  task :roles => :environment do
    Typus::Configuration.roles.each do |role|
      puts "#{role.first.capitalize} role has access to:"
      role.last.each { |key, value| puts "- #{key}: #{value}" }
    end
  end

end
