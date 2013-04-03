# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  open_file = lambda { |name| File.open(File.join(Rails.root, "spec", "fixtures", name), "r") }

  sequence(:random_string) { |n| "#{n} - #{SecureRandom.hex(45)} - #{n}" }

  factory :paste do
    ignore do
      valid true

      _valid_lilypond_file { open_file.call "BeetAnGeSample.ly" }
      _valid_mxml_file { open_file.call "BeetAnGeSample.xml" }
      _invalid_file { open_file.call "will_fail_1.xml" }           
    end

    hold false

    trait :mxml_xml_file_present do
      mxml { (valid ? _valid_mxml_file : _invalid_file) }
    end

    trait :lilypond_text_present do
      lilypond_text { (valid ? _valid_lilypond_file.read : generate(:random_string)) }
    end

    factory :paste_with_mxml,          :traits => [:mxml_xml_file_present]
    factory :paste_with_lilypond_text, :traits => [:lilypond_text_present]
    factory :paste_with_both,          :traits => [:mxml_xml_file_present, :lilypond_text_present]

    factory :paste_with_illegal_mxml do
      mxml { _valid_lilypond_file }
    end

    factory :paste_with_lilypond_file do
      lilypond { (valid ? _valid_lilypond_file : _invalid_file) }
    end
  end
end
