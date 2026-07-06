# note 025

Owner: sanitized-owner-085@example.test
Status: draft

This generated document is safe local test data for Pagepacket. It avoids customer, account, and production content.

## Summary

The file exercises Markdown editing, preview rendering, snapshot history, external-agent edits, and CLI traversal under a production-scale folder tree.

## Checklist

- [ ] Verify edit mode
- [x] Keep Markdown plain
- [ ] Review agent changes before accepting

## Table

| Area | State | Risk |
| --- | --- | --- |
| app | active | medium |
| cli | active | low |
| landing | preview | medium |

## Quote

> Human review remains the boundary before agent edits become canonical.

## Code

```sh
pagepacket-cli snapshot . engineering/rfcs/note-025.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-085-000 token-085-001 token-085-002 token-085-003 token-085-004 token-085-005 token-085-006 token-085-007 token-085-008 token-085-009 token-085-010 token-085-011 token-085-012 token-085-013 token-085-014 token-085-015 token-085-016 token-085-017 token-085-018 token-085-019 token-085-020 token-085-021 token-085-022 token-085-023 token-085-024 token-085-025 token-085-026 token-085-027 token-085-028 token-085-029 token-085-030 token-085-031 token-085-032 token-085-033 token-085-034 token-085-035 token-085-036 token-085-037 token-085-038 token-085-039 token-085-040 token-085-041 token-085-042 token-085-043 token-085-044 token-085-045 token-085-046 token-085-047
