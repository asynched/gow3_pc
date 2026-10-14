# Linux startup flip-gate workaround

On CUSA01623 01.00, a black window can persist while the intro thread polls its
frame-completion label. This is not shader-cache warm-up: the GPU command processor
is suspended at a `WAIT_REG_MEM` before the next EOP packet.

The failure reproduced with the NVIDIA driver and Lavapipe, without game patches,
and with asynchronous shader compilation and the draw pipeline disabled. A
watchpoint showed the CPU initialize the acknowledgement to `0xffffffff`, then
replace it with zero after the initial flip. The following submission was waiting
for that acknowledgement to differ from zero, with its frame-one EOP behind the
wait. Debugger timing could change the outcome.

`GOW3_BOOTSTRAP_FLIP_GATE=1` enables a **workaround**, not a general change to PM4
wait semantics. It skips at most one matching startup gate: a memory NotEqual-zero
wait with a full mask, at offset 40 in an aligned label block, immediately followed
by a frame-one EOP to the completion label 24 bytes earlier. It is off by default.
The underlying guest/host flip-ordering issue still needs a general solution.

The local build was tested for 45 seconds after enabling the workaround: about
60 FPS, over 700 draws per frame, ATRAC9 audio decoding, pad reads and save mounts.
The launcher-based local start also produced about 60 FPS.

For the locally prepared Linux build:

```sh
bash tools/run-bootstrap.sh
```

This uses the saved launcher settings and existing saves under the normal Linux
data directory. It does not modify or replace the AppImage. The script also disables
the two-stage draw pipeline for this diagnostic launch. An optional local dependency
directory at `~/.local/share/gow3-build-deps` supplies FFmpeg libraries when they are
not installed system-wide.
