namespace :data do
  desc "Obtain and ready data for import"
  task prepare: ["data:clean", "data:download", "data:patch", ]
  
  desc "Clean downloaded files from /data directory"
  task :clean do
    FileUtils.rm Dir.glob("./data/*")
  end
  
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

  desc "Apply patches to get data files compatibile with psql COPY"
  task :patch do
    command = "patch data/SCOPE_NOTES.out patches/SCOPE_NOTES.patch"
    puts command
    system command
    command = "patch data/TERM.out patches/TERM.patch"
    puts command
    system command
    command = "patch data/LANGUAGE_RELS.out patches/LANGUAGE_RELS.patch"
    puts command
    system command
  end

  desc "Import all tables"
  task import: ["import:subjects", "import:terms", "import:subject_rels", "import:associative_rels", "import:language_rels", "import:scope_notes"]

  namespace :import do
    desc "The subject table is the base table for all AAT records"
    task subjects: :environment do
      database = ActiveRecord::Base.connection.current_database
      path = File.join(Rails.root, "data", "SUBJECT.out")
      command = %Q{psql #{database} -c "COPY subjects (facet_code, legacy_id, merged_stat, parent_id, record_type, sort_order, special_proj, subject_id) FROM '#{path}' DELIMITER E'\t'"}
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

    desc "The associative relationships table stores all AAT subject-to-subject relationships (other than parent/child relationships)"
    task associative_rels: :environment do
      database = ActiveRecord::Base.connection.current_database
      path = File.join(Rails.root, "data", "ASSOCIATIVE_RELS.out")
      command = %Q{psql #{database} -c "COPY associative_rels (display_date, end_date, historic_flag, rel_type_code, start_date, subjecta_id, subjectb_id) FROM '#{path}' DELIMITER E'\t'"}
      puts command
      system command
    end

    desc "The language relationship table contains links between terms and a controlled set of languages. In subject records, only one term can be preferred for each language in a particular subject"
    task language_rels: :environment do
      database = ActiveRecord::Base.connection.current_database
      path = File.join(Rails.root, "data", "LANGUAGE_RELS.out")
      command = %Q{psql #{database} -c "COPY language_rels (language_code, preferred, subject_id, term_id, qualifier, term_type, part_of_speech, lang_stat) FROM '#{path}' DELIMITER E'\t'"}
      puts command
      system command
    end

    desc "Descriptive notes linked to a subject record associated with a particular language"
    task scope_notes: :environment do
      database = ActiveRecord::Base.connection.current_database
      path = File.join(Rails.root, "data", "SCOPE_NOTES.out")
      command = %Q{psql #{database} -c "COPY scope_notes (scope_note_id, subject_id, language_code, note_text) FROM '#{path}' DELIMITER E'\t'"}
      puts command
      system command
    end
  end

  namespace :ancestry do
    desc "Rebuild ancestry path and depth information"
    task rebuild: :environment do
      puts <<~EOF
      This is going to take a while. For details...

      tail -f log/development.log

      EOF
      puts "Building ancestry from parent_ids..."
      Subject.build_ancestry_from_parent_ids!
      puts "Rebuilding depth_cache..."
      Subject.rebuild_depth_cache!
      puts "Checking ancestry integrity..."
      Subject.check_ancestry_integrity!
      puts "Done."
    end
  end
end

namespace :db do
  desc "Create the database from scratch"
  task build: ["db:setup", "data:import"]
  
  desc "Re-create the database from scratch"
  task rebuild: ["db:drop", "db:build"]

  desc "Create (or recreate) the database from scratch with a fresh Getty data dump"
  task bootstrap: ["data:prepare", "db:rebuild"]
end

