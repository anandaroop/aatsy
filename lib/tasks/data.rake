namespace :data do
  desc "Download latest AAT data dump from Getty (http://aatdownloads.getty.edu/)"
  task :download do
    # data dump files
    SITE = "http://aatdownloads.getty.edu/VocabData"
    LATEST_DUMP = "aat_rel_1020.zip"
    command = "cd data && curl -O #{SITE}/#{LATEST_DUMP} && unzip #{LATEST_DUMP} && rm #{LATEST_DUMP}"
    puts command
    system command

    # data dictionary
    command = "cd data && curl -O https://www.getty.edu/research/tools/vocabularies/aat/aat_rel_dd.pdf"
    puts command
    system command
  end

  desc "Import all tables"
  task import: ["import:subjects", "import:terms", "import:subject_rels"]

  namespace :import do
    desc "The subject table is the base table for all AAT records"
    task subjects: :environment do
      database = ActiveRecord::Base.connection.current_database
      path = File.join(Rails.root, "data", "SUBJECT.out")
      command = %Q{psql #{database} -c "COPY subjects (facet_code, legacy_id, merged_stat, parent_key, record_type, sort_order, special_proj, subject_id) FROM '#{path}' DELIMITER E'\t'"}
      puts command
      system command
    end

    desc "The term table contains the various vocabulary entries ('terms' in AAT) for each subject record"
    task terms: :environment do
      database = ActiveRecord::Base.connection.current_database
      path = File.join(Rails.root, "data", "TERM.out")
      command = %Q{psql #{database} -c "COPY terms (aacr2_flag, display_date, display_name, display_order, end_date, historic_flag, other_flags, preferred, start_date, subject_id, term, term_id, vernacular) FROM '#{path}' DELIMITER E'\t'"}
      puts command
      system command
    end

    desc "The subject relationships table contains all preferred and non-preferred parent-child relationships in the AAT hierarchy"
    task subject_rels: :environment do
      database = ActiveRecord::Base.connection.current_database
      path = File.join(Rails.root, "data", "SUBJECT_RELS.out")
      command = %Q{psql #{database} -c "COPY subject_rels (display_date, end_date, historic_flag, preferred, rel_type, start_date, subjecta_id, subjectb_id, hier_rel_type) FROM '#{path}' DELIMITER E'\t'"}
      puts command
      system command
    end
  end
end

namespace :db do
  desc "Create the database from scratch"
  task build: ["db:create", "db:migrate", "data:import"]

  desc "Start over from scratch (╯°□°)╯︵ ┻━┻"
  task rebuild: ["db:drop", "db:build"]
end
