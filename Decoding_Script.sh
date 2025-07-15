#set -e. ./cmd.sh
. ./path.sh
. ./cmd.sh
cmd="run.pl"
#Specifies job runner. run.pl means run jobs locally.

#Could be changed to queue.pl for cluster use.

nj=1
#8
#Number of parallel jobs. Here, only 1 (no parallelization).
#/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/iitm/IITM_wpp_Retrained


#########################Acoustic Model############################
exp=/media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain/

# %%%%%%%%%%%%%%%%%%%%Acoustic-Model
# exp=/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/iitm/eng_exp_iitm_160_hrs_1
# %%%%%%%%%%%%%%%%%%%

#/media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain
#/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/iitm/IITM_wpp_Retrained
alignment_directory=/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/SNR_Experiment/MPS_All_Original_Dataset_Folder_Wise/3/PCM/234_1
#/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/KALDI_ALL_Only_ENG_VTLN_and_Original/538_2
#/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/Analysis_MPS_Enhanced_VTLN/KALDI_files_infor_backup_exp
#/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/Analysis_MPS_Enhanced_VTLN/KALDI_files_infor_backup_exp

#/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/Analysis_MPS_Enhanced_VTLN/KALDI_files_infor_backup_exp
#/home/Sharedata/sandipan/Voice_Editing_VTLN/VTLN-Experiment/Analysis_MPS_Enhanced_VTLN/KALDI_files_info

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Language-Model#######################################
lang=/media/run/kaldi/egs/gop_speechocean762/s5/data/IS24_CT_langs/lang_CT_234_2_IS24/
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###################################################

#/media/run/kaldi/egs/gop_speechocean762/s5/data/lang_IS_24_MT/234_1
#/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/data/KV_1600_CT_Langs/lang_234_1_CT
#/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/data/KV_1600_CT_Langs/lang_234_2_CT
#/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/data/KV_1600_CT_Langs/lang_234_1_CT
#lang_234_1_CT
#$1 = exp folder (where model lives)

#$2 = path to test/inference data (alignment_directory)

#$3 = path to language model and lexicon (lang) 

ivector_extractor=$exp/nnet3_cleaned/extractor

# Path to the online i-vector extractor, assumed to be inside $exp/nnet3
graph=/media/run/kaldi/egs/gop_speechocean762/s5/data/IS24_CT_langs/lang_CT_234_1_IS24/
#media/run/kaldi/egs/gop_speechocean762/s5/data/IS24_CT_langs
#graph=/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/rahul_kaldi/temp/lang_temp/graph_temp

#Initial assignment to graph path (overwritten later).



    bash utils/fix_data_dir.sh $alignment_directory
    #Fixes errors in Kaldi data dir (e.g., remove bad utterances, fix scp inconsistencies).


    #rm -r data/lang_KV_Hindi_can_full/graph_CT_Full
    rm -r data/lang_Hindi_Yash/graph_CT_Full/
    #Deletes an old decoding graph (probably to avoid conflict during re-generation).

    steps/make_mfcc.sh --nj $nj --mfcc-config conf/mfcc_hires.conf \
      --cmd "$cmd" $alignment_directory || exit 1;

    #Extracts MFCC features using high-resolution config.

    #--cmd "$cmd" lets you run with run.pl or queue.pl.

    steps/compute_cmvn_stats.sh $alignment_directory|| exit 1;

    #Computes Cepstral Mean and Variance Normalization (CMVN) stats.

    utils/fix_data_dir.sh $alignment_directory
    #Fix again after feature computation.


    steps/online/nnet2/extract_ivectors_online.sh --cmd "$cmd" --nj $nj \
      $alignment_directory $ivector_extractor $alignment_directory/alignments/ivectors
    #Extracts online i-vectors, saved under alignments/ivectors/ subdirectory

   bash utils/mkgraph.sh --self-loop-scale 0.1 $lang $exp/nnet3_cleaned/tdnn_sp data/lang_Hindi_Yash/graph_CT_Full/
    #Creates a decoding graph (HCLG.fst) from the language model.
    #Stores it in graph_CT_Full/.

    #cd /media/run/kaldi/egs/gop_speechocean762/s5
    graph=/media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain/nnet3_cleaned/tdnn_sp/graph_s2m_234_1
    #/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/rahul_kaldi/data/lang_Hindi_Yash/graph_CT_Full/
    #graph=/media/run/kaldi/egs/gop_speechocean762/s5/data/lang_IS_24_MT/234_1/tmp
    #Sets the graph path to the new one just created
    #graph=/media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/rahul_kaldi/data/lang_phone_NCERT
    
    taskset -c 0-9 ./steps/nnet3/decode.sh --acwt 1.0 --post-decode-acwt 1.0 --extra-left-context 0 --extra-right-context 0 --extra-left-context-initial 0 --extra-right-context-final 0 --frames-per-chunk 140 --nj $nj --cmd "$cmd"  --num-threads 2 --scoring-opts "--min-lmwt 1 --max-lmwt 50 --word-ins-penalty -1.0,0,1.0" --online-ivector-dir $alignment_directory/alignments/ivectors $graph $alignment_directory/ $exp/nnet3_cleaned/tdnn_sp/Inference
    
    
    best_inference_file_text= bash extract_best.sh $exp/nnet3_cleaned/tdnn_sp/Inference/scoring_kaldi/best_wer
    echo "$best_inference_file_path"
    

    # sudo taskset -c 0-9: pin to CPU cores 0–9.

    # decode.sh: runs decoding using TDNN model.

    # --acwt: acoustic weight.

    # --num-threads: decoding multithreaded.

    # --online-ivector-dir: uses previously extracted i-vectors.

    # --scoring-opts: run scoring for a range of LM weights.

    # $graph: the decoding graph.

    # $alignment_directory: test data.

    # Inference: output directory for decoded lattices, best paths, etc.  


    #cd /media/run/kaldi/egs/gop_speechocean762/s5
    #bash get_align.sh --stage 3 --nj $nj $alignment_directory $lang $exp/chain/tdnn $alignment_directory/alignments
