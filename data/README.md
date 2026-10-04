# Data

The face images used in the original experiments are **not distributed**.
They are biometric data of the people involved. To run the code, put your own
images here using this layout:

```
data/
├── gallery/            one image per known identity (this builds the face space)
│   ├── alice.png
│   └── bob.png
└── probes/             images to identify, one folder per identity
    ├── alice/          the folder name must match the gallery file name
    │   ├── captura1.png
    │   └── ...
    └── bob/
        └── ...
```

- Only `.png` files are read by default. To accept other formats, change
  `extensions` in [`src/eigenfaceConfig.m`](../src/eigenfaceConfig.m).
- Images can be any size. They are resized to QCIF (176×144) before processing.
- Only the first colour channel is used, as in the original experiments.
- In the original setup, both gallery and probes were roughly 29×29 head crops
  from a colour-based head tracker running on a surveillance-style video.

Everything except this file is ignored by git.
