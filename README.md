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
-### 🔢 Steps to Locate and View the `best_wer` File in Kaldi ASR Output

1. Identify the path where decoded text is stored by checking the `.sh` script.
   - Look for the variable: `$exp/nnet3_cleaned/tdnn_sp/Inference`.

2. Confirm that the `exp` variable points to the acoustic model path:
   
3. The full path becomes: "`exp` acoustic model path" + "/nnet3_cleaned/tdnn_sp/Inference" (as follows)
   
4. Navigate to the directory:
```bash cd /media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain/nnet3_cleaned/tdnn_sp/Inference
5. ls
6. cd scoring_kaldi
7. ls
8. cat best_wer
9. WER 25.63 [ 3974 / 15504, 1959 ins, 44 del, 1971 sub ] /media/run/kaldi/egs/gop_speechocean762/s5/exp_nnet3_retrain/nnet3_cleaned/tdnn_sp/Inference/wer_4_1.0
10. Final decoded file will be available in: penalty1.0 and then 4.txt file






