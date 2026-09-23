# quartz-notes

Obsidian 笔记 → Quartz 静态站点 → GitHub Pages 工作流骨架。

## 结构

| 路径 | 作用 |
|------|------|
| `D:/BPP/EZNote` | Obsidian 笔记库（本地保留，暂不迁移） |
| `D:/BPP/Repos/quartz-notes` | Quartz 站点仓库（本仓库） |
| `content/` | 站点内容（迁移后由同步脚本填充，当前为空） |
| `sync-notes.ps1` | EZNote → content 一键同步 + git push |
| `.github/workflows/deploy.yml` | push 到 `v5` 自动构建并部署 Pages |

## 连接关系

```
Obsidian (EZNote)
    │  pwsh -File sync-notes.ps1
    ▼
quartz-notes/content  ──git push──▶  GitHub (EZzer0/quartz-notes @ v5)
                                          │
                                          ▼  Actions
                                    GitHub Pages
                                    https://ezzer0.github.io/quartz-notes/
```

## 日常同步（笔记整理好后）

```powershell
cd D:/BPP/Repos/quartz-notes
pwsh -File sync-notes.ps1
```

- 只复制、不推送：`pwsh -File sync-notes.ps1 -NoPush`
- 笔记尚未迁移时，脚本不会改动 `content/`

## 本地预览

```powershell
cd D:/BPP/Repos/quartz-notes
npm ci
npx quartz plugin install
npx quartz build --serve
```

## 发布状态

- 仓库：https://github.com/EZzer0/quartz-notes （Public）
- 分支：`v5`（与上游 Quartz 一致）
- Pages 源：GitHub Actions
- baseUrl：`ezzer0.github.io/quartz-notes`
