# Multi-arch handoff

A maintenance run has to keep going when the next worker is a different machine and a different SDK. The early steps stay saved.

> PiHerder is not Pi-only. If you can SSH into it, it can be a host. The control plane itself is multi-arch, so it runs on a Pi or an x86 machine.
>
> — [Björn Glück](https://x.com/BjornCPT/status/2114241469334646813)

> I run AI agents on four platforms and a Mac Mini. I never knew which one was stuck.
>
> — [Mark R. Hinkle](https://x.com/mrhinkle/status/2110440808646353055)

The run has six steps over a fake inventory: `inventory`, `backup`, `plan_updates`, `apply-host-1`, `apply-host-2`, and `audit`. `backup` writes one object to RustFS. Each step output is `{step, machine, body}`. `machine` is `platform.machine()` in Python and `os.machine()` in TypeScript. The task result is the audit body only: hosts, plan, applied hosts, and the backup sha256. It does not include the machine name.

That split is deliberate. A handoff from x86_64 to aarch64 cannot have the same machine trace as a single-architecture run. The audit, which is the maintenance result, is byte-identical to a clean amd64 run. The comparison is canonical JSON of that result.

From the repository root, with RustFS up and qemu registered for the architecture you are not:

```sh
python tests/multi_arch_handoff_demo.py
```

The test builds `worker-amd64` and `worker-arm64` (`platform:` in `compose.yaml`; the Dockerfile maps `TARGETARCH` to the `linux-x64` or `linux-arm64` deoos archive). It kills the amd64 Python worker after `backup`, and an arm64 TypeScript worker finishes. It then does the reverse. Inventory and backup each run once. The bucket has one backup object. If the offline bundle has already downloaded both Linux archives into `docker/offline-tarballs/`, those image builds use the local files instead of GitHub.

On an amd64 GitHub Actions runner, `.github/workflows/examples.yml` registers qemu with `docker/setup-qemu-action` before the tests.

Evidence stays in `outputs/multi-arch-handoff/`. The workflow is `maintain.py`. The TypeScript twin is `typescript/multi-arch-handoff/maintain.mjs`.
