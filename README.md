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
