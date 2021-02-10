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
end
