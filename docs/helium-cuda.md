---
title: Helium-cuda set up
---

This document contains commands and expected outputs that you'll encounter
while setting up the helium-cuda VM.

# Find PCI device information

See: <https://www.theseus-os.com/Theseus/book/running/virtual_machine/pci_passthrough.html>

I already know that my GPU has the PCI path `01:00`.

```bash
sudo lspci -vnn -s 01:00
```

```
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA102 [GeForce RTX 3090 Ti] [10de:2203] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Micro-Star International Co., Ltd. [MSI] Device [1462:5091]
	Flags: fast devsel, IRQ 16, IOMMU group 19
	Memory at 81000000 (32-bit, non-prefetchable) [size=16M]
	Memory at 6000000000 (64-bit, prefetchable) [size=32G]
	Memory at 6800000000 (64-bit, prefetchable) [size=32M]
	I/O ports at 5000 [size=128]
	Expansion ROM at 82000000 [disabled] [size=512K]
	Capabilities: <access denied>
	Kernel driver in use: vfio-pci
	Kernel modules: nvidiafb, nouveau

01:00.1 Audio device [0403]: NVIDIA Corporation GA102 High Definition Audio Controller [10de:1aef] (rev a1)
	Subsystem: Micro-Star International Co., Ltd. [MSI] Device [1462:5091]
	Flags: bus master, fast devsel, latency 0, IRQ 17, IOMMU group 19
	Memory at 82080000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel
```

Note the following values from the `lspci` output:

1. VGA compatible controller
  1. `slot_info`: 0000:01:00.0
  2. `vendor_id`: 10de
  3. `device_code`: 2203
2. Audio device
  1. `slot_info`: 0000:01:00.1
  2. `vendor_id`: 10de
  3. `device_code`: 1aef

I've found that forwarding both devices works better for PCI forwarding.

# Libvirt PCI name

Here's how to find the name for the two devices in libvirt. You need
these names to set up PCI forwarding. The `slot_info` 0000:01:00.0
becomes `pci_0000_01`.

Run this command:

```
virsh nodedev-list | grep pci_0000_01
```

You should see the following:

```
pci_0000_01_00_0
pci_0000_01_00_1
```

# Virt-install invocation

These instructions use virt-install to automate loading a NixOS image
into a virtual machine.

Here's what the virt-install `--help` help says about PCI forwarding:

> Device Options
>
> --host-device=HOSTDEV
> Attach a physical host device to the guest. Some example values for HOSTDEV:
> --host-device pci_0000_00_1b_0
>     A node device name via libvirt, as shown by 'virsh nodedev-list'
> --host-device 001.003
>     USB by bus, device (via lsusb).
> --host-device 0x1234:0x5678
>     USB by vendor, product (via lsusb).
> --host-device 1f.01.02
>     PCI device (via lspci).
> --soundhw MODEL
> Attach a virtual audio device to the guest. MODEL specifies the emulated sound card model. Possible values are ich6, ac97, es1370, sb16, pcspk, or default. 'default' will be AC97 if the hypervisor supports it, otherwise it will be ES1370 .

Source: <https://linux.die.net/man/1/virt-install>

For PCI forwarding, you need the `--host-device` flag.

# Build qcow2 image

Build a qcow2 image to load into virt-install:

```bash
cp --no-preserve=all $(nix build .#nixosConfigurations.helium-cuda.config.system.build.qcow --print-out-paths --no-link)/helium-cuda.qcow2 .
```

```bash
file nixos.qcow2
```

You should see the following:

```
nixos.qcow2: QEMU QCOW Image (v3), 27473739776 bytes (v3), 27473739776 bytes
```

Build the image and create a new virtual machine with `virt-install`:

```
cp --no-preserve=all $(nix build .#nixosConfigurations.helium-cuda.config.system.build.qcow --print-out-paths --no-link)/helium-cuda.qcow2 .
virt-install --connect qemu:///system \
  --import \
  --name helium-cuda \
  --memory 60000 \
  --vcpus 16 \
  --disk helium-cuda.qcow2 \
  --os-variant nixos-unstable \
  --network default \
  --host-device pci_0000_01_00_0 \
  --host-device pci_0000_01_00_1 \
  --boot uefi
```

Once VM starts up, test

```bash
ssh helium-cuda.local uname -a
```

Should output:

```
Linux helium-cuda 6.12.87 #1-NixOS SMP PREEMPT_DYNAMIC Fri May  8 06:39:25 UTC 2026 x86_64 GNU/Linux
```

Print NVIDIA driver information:

```bash
ssh helium-cuda.local nvidia-smi
```

Should output:

```
Mon May 18 07:08:44 2026
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 570.172.08             Driver Version: 570.172.08     CUDA Version: 12.8     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3090 Ti     Off |   00000000:05:00.0 Off |                  Off |
| 32%   46C    P0            N/A  /  450W |       0MiB /  24564MiB |      0%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+

+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|  No running processes found                                                             |
+-----------------------------------------------------------------------------------------+
```

# Add debian user to docker group

Next, try vLLM.

```
Welcome to fish, the friendly interactive shell
Type help for instructions on how to use fish
debian@helium-cuda ~> docker run --runtime nvidia --gpus all \
                              -v ~/.cache/huggingface:/root/.cache/huggingface \
                              -p 8000:8000 \
                              --ipc=host \
                              vllm/vllm-openai:latest \
                              --model Qwen/Qwen3-0.6B
docker: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Head "http://%2Fvar%2Frun%2Fdocker.sock/_ping": dial unix /var/run/docker.sock: connect: permission denied
```

Learn that you need to add debian to docker group.
Update configuration, copy new configuration:

```bash
nixos-rebuild --flake .#helium-cuda switch --target-host root@helium-cuda.local
```

# Grow VM disk image

Try one more time:

```
ssh helium-cuda.local docker run --runtime nvidia --gpus all \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -p 8000:8000 \
  --ipc=host \
  vllm/vllm-openai:latest \
  --model Qwen/Qwen3-0.6B
```

Source: <https://docs.vllm.ai/en/stable/deployment/docker/>

After a while:

```

9c682ea8589b: Download complete
7fdb1261272c: Verifying Checksum
7fdb1261272c: Download complete
7fdb1261272c: Pull complete
docker: failed to register layer: write /usr/local/lib/python3.12/dist-packages/flashinfer_jit_cache/jit_cache/single_decode_with_kv_cache_dtype_q_f16_dtype_kv_e4m3_dtype_o_f16_head_dim_qk_128_head_dim_vo_128_posenc_0_use_swa_False_use_logits_cap_False/single_decode_with_kv_cache_dtype_q_f16_dtype_kv_e4m3_dtype_o_f16_head_dim_qk_128_head_dim_vo_128_posenc_0_use_swa_False_use_logits_cap_False.so: no space left on device
```

Run the following command on the host. You don't need to shut down the VM.

```bash
virsh -c qemu:///system blockresize helium-cuda $PWD/helium-cuda.qcow2 --size 100G
```

On the guest, run these commands as root:

```bash
growpart /dev/vda 3
resize2fs /dev/vda3
lsblk
```

Here's the expected output for these three commands:

```
[root@helium-cuda:~]# growpart /dev/vda 3
CHANGED: partition=3 start=526336 old: size=54728704 end=55255039 new: size=209188831 end=209715166

[root@helium-cuda:~]# resize2fs /dev/vda3
resize2fs 1.47.3 (8-Jul-2025)
Filesystem at /dev/vda3 is mounted on /; on-line resizing required
old_desc_blocks = 4, new_desc_blocks = 13
The filesystem on /dev/vda3 is now 26148603 (4k) blocks long.


[root@helium-cuda:~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    253:0    0  100G  0 disk
├─vda1 253:1    0  249M  0 part /boot
├─vda2 253:2    0 1007K  0 part
└─vda3 253:3    0 99.7G  0 part /nix/store
                                /
```

# Test vLLM again

Run this command on the host:

```bash
ssh helium-cuda.local docker run --gpus all \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -p 8000:8000 \
  --rm --interactive \
  --name vllm --ipc=host \
  vllm/vllm-openai:latest --model Qwen/Qwen3-0.6B
```

vLLM spins for a while and then prints the following:

```
(EngineCore pid=151) INFO 05-18 08:00:26 [jit_monitor.py:54] Kernel JIT monitor activated — Triton JIT compilations during inference will be logged as warnings.
(EngineCore pid=151) INFO 05-18 08:00:26 [core.py:299] init engine (profile, create kv cache, warmup model) took 18.03 s (compilation: 10.69 s)
(EngineCore pid=151) Warning: You are sending unauthenticated requests to the HF Hub. Please set a HF_TOKEN to enable higher rate limits and faster downloads.
(EngineCore pid=151) INFO 05-18 08:00:28 [vllm.py:886] Asynchronous scheduling is enabled.
(EngineCore pid=151) INFO 05-18 08:00:28 [kernel.py:212] Final IR op priority after setting platform defaults: IrOpPriorityConfig(rms_norm=['native'], fused_add_rms_norm=['native'])
(APIServer pid=1) INFO 05-18 08:00:28 [api_server.py:613] Supported tasks: ['generate']
(APIServer pid=1) WARNING 05-18 08:00:28 [model.py:1454] Default vLLM sampling parameters have been overridden by the model's `generation_config.json`: `{'temperature': 0.6, 'top_k': 20, 'top_p': 0.95}`. If this is not intended, please relaunch vLLM instance with `--generation-config vllm`.
(APIServer pid=1) INFO 05-18 08:00:31 [hf.py:483] Detected the chat template content format to be 'string'. You can set `--chat-template-content-format` to override this.
(APIServer pid=1) INFO 05-18 08:00:32 [api_server.py:617] Starting vLLM server on http://0.0.0.0:8000
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:37] Available routes are:
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /openapi.json, Methods: HEAD, GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /docs, Methods: HEAD, GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /docs/oauth2-redirect, Methods: HEAD, GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /redoc, Methods: HEAD, GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /tokenize, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /detokenize, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /load, Methods: GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /version, Methods: GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /health, Methods: GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /metrics, Methods: GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/models, Methods: GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /ping, Methods: GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /ping, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /invocations, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/chat/completions, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/chat/completions/batch, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/responses, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/responses/{response_id}, Methods: GET
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/responses/{response_id}/cancel, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/completions, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/messages, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/messages/count_tokens, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /inference/v1/generate, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /scale_elastic_ep, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /is_scaling_elastic_ep, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /generative_scoring, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/chat/completions/render, Methods: POST
(APIServer pid=1) INFO 05-18 08:00:32 [launcher.py:46] Route: /v1/completions/render, Methods: POST
```

On the host, list all available models with the following command:

```bash
curl http://helium-cuda.local:8000/v1/models
```

This should print the following

```json
{"object":"list","data":[{"id":"Qwen/Qwen3-0.6B","object":"model","created":1779091304,"owned_by":"vllm","root":"Qwen/Qwen3-0.6B","parent":null,"max_model_len":40960,"permission":[{"id":"modelperm-be5911bf71c7917c","object":"model_permission","created":1779091304,"allow_create_engine":false,"allow_sampling":true,"allow_logprobs":true,"allow_search_indices":false,"allow_view":true,"allow_fine_tuning":false,"organization":"*","group":null,"is_blocking":false}]}]}⏎
```

Ask the `Qwen/Qwen3-0.6B` model what the capital of Crance is with this
curl command:


```bash
curl http://helium-cuda.local:8000/v1/chat/completions \
  --json '{"model":"Qwen/Qwen3-0.6B","messages":[{"role":"user","content":"Capital of France?"}],"max_tokens":200}'
```

You should see the following:

```
{"id":"chatcmpl-8d6890852231f4b1","object":"chat.completion","created":1779091337,"prompt_routed_experts":null,"model":"Qwen/Qwen3-0.6B","choices":[{"index":0,"message":{"role":"assistant","content":"<think>\nOkay, the user is asking about the capital of France. I know the answer is Paris. But maybe they want more details. Let me check if there's any other information they might be interested in. France's capital is indeed Paris. I should confirm that and maybe mention some key points about the capital to provide a comprehensive answer.\n</think>\n\nThe capital of France is **Paris**. It is a major city in northern France, known for its historical significance and cultural importance.","refusal":null,"annotations":null,"audio":null,"function_call":null,"tool_calls":[],"reasoning":null},"logprobs":null,"finish_reason":"stop","stop_reason":null,"token_ids":null,"routed_experts":null}],"service_tier":null,"system_fingerprint":"vllm-0.21.0-60f1139f","usage":{"prompt_tokens":12,"total_tokens":111,"completion_tokens":99,"prompt_tokens_details":null},"prompt_logprobs":null,"prompt_token_ids":null,"prompt_text":null,"kv_transfer_params":null}⏎
```

# Club-3090

Next, set up club-3090. Connect to `helium-cuda.local` with ssh.

```bash
ssh helium-cuda.local
```

Run these commands:
```
git clone https://github.com/noonghunna/club-3090.git
cd club-3090
```

Verify that your user already has the `MODEL_DIR` environment variable set
by running the following:

```bash
echo $MODEL_DIR
```

This should print the following:

```
/home/debian/models
```

Now run the club-3090 setup withe the following command:

```bash
scripts/setup.sh qwen3.6-27b
```

This should print the following:

```
[preflight] checking environment...
[preflight] docker:  28.5.2 (compose v2 ok)
[preflight] gpu:     1× detected
[preflight]            GPU 0: NVIDIA GeForce RTX 3090 Ti (UUID: GPU-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
[preflight] disk:    61 GB free at /home/debian/models (need ~25 GB)
[preflight] WARNING: HF_TOKEN is not set in the environment.
[preflight]          Qwen3.6-27B is T&C-gated on HuggingFace; downloads will fail without a token.
[preflight]          Fix: visit https://huggingface.co/settings/tokens, create a read token,
[preflight]               accept the model T&C at https://huggingface.co/Qwen/Qwen3-Next-80B-A3B-Instruct
[preflight]               (and any other Qwen3-Next variant you'll use),
[preflight]               then export HF_TOKEN=hf_... in your shell or .env file.
[preflight] ok.

Setup root:   /home/debian/club-3090
Model dir:    /home/debian/models
[genesis] Already cloned at /home/debian/club-3090/models/qwen3.6-27b/vllm/patches/genesis — fetching + checking out 7b9fd319 ...
HEAD is now at 7b9fd31 release(v7.72.2): PN70 schema subset filter + Proxmox VE installer caveat
[genesis] Pinned to 7b9fd319 (7b9fd31)
[model]   Using 'hf download' (hf_transfer if available) ...
/home/debian/.local/share/pipx/venvs/huggingface-hub/lib/python3.13/site-packages/huggingface_hub/constants.py:277: FutureWarning: The `HF_HUB_ENABLE_HF_TRANSFER` environment variable is deprecated as 'hf_transfer' is not used anymore. Please use `HF_XET_HIGH_PERFORMANCE` instead to enable high performance transfer with Xet. Visit https://huggingface.co/docs/huggingface_hub/package_reference/environment_variables#hfxethighperformance for more details.
  warnings.warn(
Ignored error while writing commit hash to /home/debian/.cache/huggingface/hub/models--Lorbus--Qwen3.6-27B-int4-AutoRound/refs/main: [Errno 13] Permission denied: '/home/debian/.cache/huggingface/hub/models--Lorbus--Qwen3.6-27B-int4-AutoRound'.
Downloading (incomplete total...): 0.00B [00:00, ?B/s]                                                                   Warning: You are sending unauthenticated requests to the HF Hub. Please set a HF_TOKEN to enable higher rate limits and faster downloads.
Downloading (incomplete total...):   1%|▏                                            | 83.9M/16.2G [00:02<06:16, 42.7MB/s]
Fetching 22 files:   5%|███                                                                | 1/22 [00:00<00:05,  3.54it/s]
...
[done]    11 shards SHA-verified.
          Genesis pinned at 7b9fd319 (7b9fd31).

[dflash]  Skipping DFlash draft model. Set WITH_DFLASH_DRAFT=1 to fetch
          z-lab/Qwen3.6-27B-DFlash (~1.75 GB; required only for dual-dflash composes).

[setup] ✓ Qwen 3.6 27B downloaded.
[setup] Next: bash scripts/launch.sh

Next — single-card vLLM (default):
  cd models/qwen3.6-27b/vllm/compose && docker compose up -d
  docker logs -f vllm-qwen36-27b

Or dual-card vLLM (Marlin patched files already vendored in-repo):
  cd models/qwen3.6-27b/vllm/compose && docker compose -f dual/docker-compose.yml up -d

Sanity test (after 'Application startup complete'):
  curl -sf http://localhost:8020/v1/chat/completions \
    -H 'Content-Type: application/json' \
    -d '{"model":"qwen3.6-27b-autoround","messages":[{"role":"user","content":"Capital of France?"}],"max_tokens":200}'
```

# Launching vLLM

Launch the club-3090 vLLM with the following command:

```bash
scripts/launch.sh --variant vllm/default
```

# Disappearing vLLM container

```
[preflight] checking environment...
[preflight] docker:  28.5.2 (compose v2 ok)
[preflight] gpu:     1× detected
[preflight]            GPU 0: NVIDIA GeForce RTX 3090 Ti (UUID: GPU-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
[preflight] ok.


[launch] selected variant: vllm/default

[switch] no club-3090 container running
[preflight] hardware: vllm/default TP=1 requires >=24 GB; auto-selected GPU 0 (24 GB, sm_8.6)
[switch] bringing up: vllm/default  (models/qwen3.6-27b/vllm/compose/single/docker-compose.yml)
[switch] vLLM nightly SHA: 01d4d1ad375dc5854779c593eee093bcebb0cada
[+] Running 1/1
 ✘ vllm-qwen36-27b Error manifest for vllm/vllm-openai:nightly-01d4d1ad375dc5854779c593eee...                        1.8s
Error response from daemon: manifest for vllm/vllm-openai:nightly-01d4d1ad375dc5854779c593eee093bcebb0cada not found: manifest unknown: manifest unknown
```

Try an older club-3090 version:

```bash
git reset --hard v0.7.2
# HEAD is now at d116ba9 feat(launch): add hardware topology advisor
```

Run the club-3090 vLLM launcher again.

```bash
scripts/launch.sh --variant vllm/default
```

This should output the following:

```
[preflight] checking environment...
[preflight] docker:  28.5.2 (compose v2 ok)
[preflight] gpu:     1× detected
[preflight]            GPU 0: NVIDIA GeForce RTX 3090 Ti (UUID: GPU-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
...
[preflight] WARN:  Your club-3090 checkout is 97 commit(s) behind origin/master.
[preflight]          (last origin fetch: just now)
[preflight]        Master may have new configs, patches, or Genesis pin bumps.
[preflight]        Easy upgrade:  bash scripts/update.sh
[preflight]        (Will refuse if you have local edits — commit or stash first.)
[preflight]        Skip this check:  PREFLIGHT_NO_FETCH=1 bash scripts/launch.sh
[preflight] ok.


[launch] selected variant: vllm/default

...
[+] Running 2/2
 ✔ Network single_default     Created                                                                                0.1s
 ✔ Container vllm-qwen36-27b  Started                                                                                0.6s
[switch] waiting for http://localhost:8020/v1/models (container=vllm-qwen36-27b, timeout 600s)...
[switch]   28s — Resolved architecture: Qwen3_5ForConditionalGeneration
[switch]   32s — Resolved architecture: Qwen3_5MTP
[switch]   56s — Loading weights
[switch]   60s elapsed, still waiting...
[switch]   80s — Capturing CUDA graphs
[switch]   92s — Application startup complete
[switch] ✓ ready (92s)
[switch] done. Try:  curl -s http://localhost:8020/v1/models | jq .

[launch] running verify-full.sh against the new server (URL=http://localhost:8020, CONTAINER=vllm-qwen36-27b)...

Running FULL functional test against http://localhost:8020
  model=qwen3.6-27b-autoround  container=vllm-qwen36-27b  engine=vllm

[1/8] Server reachable on /v1/models ...
  ✓ server is serving
[2/8] Genesis patches applied ...
  ✓ Genesis patches applied (apply_all completed clean)
[3/8] Basic completion — capital of France ...
  ✓ reply contains 'Paris'
[4/8] Tool calling ...
  ✓ tool_calls[] populated with get_weather
[5/8] Streaming (SSE) ...
  ✓ streamed 10 chunks, 72 chars:  Staring at the code, One missing semicolon hides, Found it, joy returns. ...
[6/8] Thinking / reasoning mode ...
  ✓ reasoning 603 chars, content 3 chars (finish=stop)
    reasoning: Here's a thinking process:  1.  **Analyze User Input:**    -...
    content:     4...
[7/8] Output quality / cascade detection (2K-token completion) ...
  ✓ output OK — 9154 chars, variety=0.670, max_line_repeat=0, finish=stop
[8/8] MTP acceptance length threshold ...
  ✓ MTP acceptance length = 2.50 (>=2.0 — spec-decode contributing)

All checks passed. Stack is ready for full-functionality use.

[launch] done. Endpoint: http://localhost:8020
[launch] sample request:
  curl -sf http://localhost:8020/v1/chat/completions \
    -H 'Content-Type: application/json' \
    -d '{"model":"qwen3.6-27b-autoround","messages":[{"role":"user","content":"Capital of France?"}],"max_tokens":200}'

[launch] switch later with:  bash scripts/switch.sh <variant>
[launch] list variants:      bash scripts/switch.sh --list
```

Note the model name `qwen3.6-27b-autoround`.

Test the model on the host with the following command:

```bash
curl http://helium-cuda.local:8020/v1/chat/completions \
  --json '{"model":"qwen3.6-27b-autoround","messages":[{"role":"user","content":"Capital of France?"}],"max_tokens":200}'
```

# Appendix

## Remove VM

Remove the `helium-cuda` VM with these two commands:

```bash
virsh -c qemu:///system destroy helium-cuda
# --nvram flag needed because of UEFI
virsh -c qemu:///system undefine helium-cuda --nvram
```
