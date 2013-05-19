#
# Copyright (C) 2012 cogroo <cogroo@cogroo.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ -z "$CORPUS_ROOT" ]; then
    echo "Need to set CORPUS_ROOT"
    exit 1
fi

export MAVEN_OPTS="-Xms512m -Xmx1100m -XX:PermSize=256m"

cogrooCLI () {
	mvn -f pom-util.xml -e -q exec:java "-Dexec.mainClass=org.cogroo.gc.cmdline.CLI" "-Dexec.args=$*"
}

opennlpCLI () {
	mvn -f pom-util.xml -e -q exec:java "-Dexec.mainClass=opennlp.tools.cmdline.CLI" "-Dexec.args=$*"
}

morfologicCLI() {
	mvn -f pom-util.xml -e -q exec:java "-Dexec.mainClass=morfologik.tools.Launcher" "-Dexec.args=$*"
}

# create cogroo files
perl createCogrooFile.pl

# vars
BASE_PARAM="-inputFile ../out/cogroo/tagdict.txt -corpus ${CORPUS_ROOT}/Bosque/Bosque_CF_8.0.ad.txt -encoding "UTF-8" -allowInvalidFeats false"

TS="sh cogroo TabSeparatedPOSDictionaryBuilder"
SYNTH="awk -f synthesis.awk"

mkdir -p ../target/tmp

## Features

FOLDER=../target/dict/fsa_dictionaries/featurizer
mkdir -p ${FOLDER}
 
OUT=../target/tmp/feats
FINAL=${FOLDER}/pt_br_feats
 
cogrooCLI TabSeparatedPOSDictionaryBuilder -isIncludeFeatures true -includeFromCorpus false -outputFile ${OUT}.txt $BASE_PARAM

$SYNTH ${OUT}.txt > ${OUT}_synth.txt
morfologicCLI tab2morph -inf -i ${OUT}.txt -o ${OUT}-enc.txt
morfologicCLI fsa_build -f CFSA2 -i ${OUT}-enc.txt -o ${FINAL}.dict
morfologicCLI tab2morph -inf -i ${OUT}_synth.txt -o ${OUT}-enc_synth.txt
morfologicCLI fsa_build -f CFSA2 -i ${OUT}-enc_synth.txt -o ${FINAL}_synth.dict


## POS - jspell

FOLDER=../target/dict/fsa_dictionaries/pos
mkdir -p ${FOLDER}

OUT=../target/tmp/jspell
FINAL=${FOLDER}/pt_br_jspell

cogrooCLI TabSeparatedPOSDictionaryBuilder -isIncludeFeatures false -includeFromCorpus false -outputFile ${OUT}.txt $BASE_PARAM

$SYNTH ${OUT}.txt > ${OUT}_synth.txt
morfologicCLI tab2morph -inf -i ${OUT}.txt -o ${OUT}-enc.txt
morfologicCLI fsa_build -f CFSA2 -i ${OUT}-enc.txt -o ${FINAL}.dict
morfologicCLI tab2morph -inf -i ${OUT}_synth.txt -o ${OUT}-enc_synth.txt
morfologicCLI fsa_build -f CFSA2 -i ${OUT}-enc_synth.txt -o ${FINAL}_synth.dict


## POS - jspell + corpus

OUT=../target/tmp/jspell_corpus
FINAL=../target/dict/fsa_dictionaries/pos/pt_br_jspell_corpus

cogrooCLI TabSeparatedPOSDictionaryBuilder -isIncludeFeatures false -includeFromCorpus true -outputFile ${OUT}.txt $BASE_PARAM

$SYNTH ${OUT}.txt > ${OUT}_synth.txt
morfologicCLI tab2morph -inf -i ${OUT}.txt -o ${OUT}-enc.txt
morfologicCLI fsa_build -f CFSA2 -i ${OUT}-enc.txt -o ${FINAL}.dict
morfologicCLI tab2morph -inf -i ${OUT}_synth.txt -o ${OUT}-enc_synth.txt
morfologicCLI fsa_build -f CFSA2 -i ${OUT}-enc_synth.txt -o ${FINAL}_synth.dict


## POS - corpus

# ??

## Transitividade

## POS - jspell + corpus

OUT=../target/tmp/trans
FINAL=../target/dict/fsa_dictionaries/pos/pt_br_trans

morfologicCLI tab2morph -inf -i ../out/cogroo/trans.txt -o ${OUT}-enc.txt
morfologicCLI fsa_build -f CFSA2 -i ${OUT}-enc.txt -o ${FINAL}.dict

## XML

FOLDER=../target/dict/xml_dictionaries/pos
mkdir -p ${FOLDER}

XML=${FOLDER}/tagdict.xml

cogrooCLI POSDictionaryBuilder -outputFile ${XML} $BASE_PARAM

## Abbreviation dictionary

FOLDER=../target/dict/xml_dictionaries/abbr
mkdir -p ${FOLDER}

ABB_TXT=../DIC/non.jspell.abbr.txt
ABB_XML=${FOLDER}/abbr.xml

opennlpCLI DictionaryBuilder -inputFile ${ABB_TXT} -outputFile ${ABB_XML} -encoding ISO-8859-1 
