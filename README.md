# so-vits-svc-fork-tutorial
Using [so-vits-svc-fork](https://github.com/voicepaw/so-vits-svc-fork) in a Docker Environment

This project demonstrates how to utilize so-vits-svc-fork within a Docker environment. Before diving in, there are some essential materials you should prepare:

1. **Speaker’s Voice**: This is used for SVC (Speaker-Verification Code) training. Ensure that the voice recording is clean and single-source.
2. **Author’s Voice**: This voice is employed to transform the Speaker’s voice into the Author’s voice.

Here are the voice sources I used for SVC training:
- [Speaker’s Voice](https://www.kaggle.com/datasets/etaifour/trump-speeches-audio-and-word-transcription)
- [Author's voice](https://www.looperman.com/acapellas/genres/rap-acapellas-vocals-sounds-samples-download)

Additionally, if you need to convert MP3 files to WAV format, you can use this simple online converter:
- [MP3 to WAV Converter](https://www.freeconvert.com/mp3-to-wav)

## Getting Started
- **Install Docker**: Make sure you have Docker installed on your computer.
- **Check CPU Architecture**: Note that PyTorch does not support ARM architecture. If you’re using a Mac M1, remember build `svc-arm64` container

## Organizing the Voices
To get started, let’s organize the voice files:
- If you’ve just downloaded the Speaker’s voice, move it to the `storage/dataset_raw_raw` folder. We’ll split it into smaller pieces within the Docker container.

- If you already have pre-processed Speaker’s voice, move it to the `storage/dataset_raw` folder.

## Steps
1. Build docker image
```shell
cd hermeslin/so-vits-svc-tutorial

## if your CPU architecture is amd64
docker compose build svc-arm64

## Or just running
docker compose build svc
```

2. Test the command, You should see the result image below after running:
```shell
docker compose run svc-arm64 --help

Usage: svc [OPTIONS] COMMAND [ARGS]...

  so-vits-svc allows any folder structure for training data.
  However, the following folder structure is recommended.
      When training: dataset_raw/{speaker_name}/**/{wav_name}.{any_format}
      When inference: configs/44k/config.json, logs/44k/G_XXXX.pth
  If the folder structure is followed, you DO NOT NEED TO SPECIFY model path, config path, etc.
  (The latest model will be automatically loaded.)
  To train a model, run pre-resample, pre-config, pre-hubert, train.
  To infer a model, run infer.

Options:
  -h, --help  Show this message and exit.

Commands:
  clean          Clean up files, only useful if you are using the default file structure
  gui            Opens GUI for conversion and realtime inference
  infer          Inference
  onnx           Export model to onnx (currently not working)
  pre-classify   Classify multiple audio files into multiple files
  pre-config     Preprocessing part 2: config
  pre-hubert     Preprocessing part 3: hubert If the HuBERT model is not found, it will be...
  pre-resample   Preprocessing part 1: resample
  pre-sd         Speech diarization using pyannote.audio
  pre-split      Split audio files into multiple files
  train          Train model If D_0.pth or G_0.pth not found, automatically download from hub.
  train-cluster  Train k-means clustering
  vc             Realtime inference from microphone

## or you want to login to the container
docker compose run --rm --entrypoint /bin/bash svc-arm64
```

3. If your Speaker’s voice audio file is too large for training, consider splitting it into smaller pieces. You can choose 10 to 20 representative pieces for training.
```shell
docker compose run svc-arm64 pre-split -o dataset_raw/Trump
```

4. Pre-processing the Raw Dataset:
  - Resample the audio files:
```shell
docker compose run svc-arm64 pre-resample
```
  - Configure the dataset:
```shell
docker compose run svc-arm64 pre-config
```
  - Choose an F0-method (e.g., crepe|crepe-tiny|parselmouth|dio|harvest). By default, svc uses `dio`:
```shell
docker compose run svc-arm64 pre-hubert -fm crepe
```

5. Start Training. Training will take several minutes:
```shell
docker compose run svc-arm64 train -t
```

6. Convert Speaker’s Voice to Author’s Voice:
```shell
svc infer audio/{YOUR_AUTHORS_VOICE_FILE_NAME}.wav
```

7. View the Result:
  - Your trained Author’s voice will appear in the audio folder as `audio/{YOUR_AUTHORS_VOICE_FILE_NAME}.out.wav`.