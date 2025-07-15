### 🧠 Acoustic Model (AM) and Language Model (LM) Description

- **Acoustic Model (AM):**
  - Trained on **IITM English** dataset.
  - Fine-tuned on the **WPP dataset**.
  - Kaldi AM training path:
    ```
    /media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/iitm/eng_exp_iitm_160_hrs_1
    ```

- **Language Model (LM):**
  - A **canonical trigram LM**.
  - Includes a **parallel branch** for garbage (OOV) words occurring in **MT** transcripts with frequency > 4.
  - Kaldi LM training path:
    ```
    /media/run/kaldi/egs/iitm_baseline/English_ASR_Challenge/asr/rahul_kaldi/temp_1/
    ```

- **Reference & Supplementary Material:**
  - 📎 [Supplementary Info - Interspeech 2024 Submission](https://lapis-homegrown-710.notion.site/Supplementary-material-Interspeech-2024-submission-810faeb994bd4607aafdb7b12b730f55)

- **After executing the .sh script**
- The decoded text will be present in the location of $exp/nnet3_cleaned/tdnn_sp/Inference (go to the .sh script and find this location in the code)
- Now cd to the following location (decoded text will be present in the following path): 
- exp=/media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain/ (must be mentioned in the script, it is acoustic models' path) after that /nnet3_cleaned/tdnn_sp/Inference (it is also mention in the code of.sh)
- do change directory to this /media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain/nnet3_cleaned/tdnn_sp/Inference
- once you entered to this location, then do "ls"
- you can see "scoring_kaldi" folder
- cd to that folder
- do ls
- then you can see best_wer
- then execute this command " cat  best_wer"
- you can get something like the following
-  WER 25.63 [ 3974 / 15504, 1959 ins, 44 del, 1971 sub ] /media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain//nnet3_cleaned/tdnn_sp/Inference/wer_4_1.0
-  See the last part wer_4_1.0
-  that means inside penalty 1.o folder 4.txt has the decoded text
