# Task 4: AI
CloudNaturalLanguageLocation='gs://qwiklabs-gcp-04-199744ea43de-marking/task4-cnl-754.result'
echo $CloudNaturalLanguageLocation
CloudNaturalLanguageTemp=CloudNaturalLanguageTemp.json

gcloud ml language analyze-entities \
    --content="Old Norse texts portray Odin as one-eyed and long-bearded, frequently wielding a spear named Gungnir and wearing a cloak and a broad hat." \
    > $CloudNaturalLanguageTemp

gsutil cp $CloudNaturalLanguageTemp $CloudNaturalLanguageLocation
