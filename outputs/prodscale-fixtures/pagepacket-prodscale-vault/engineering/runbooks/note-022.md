# note 022

Owner: sanitized-owner-112@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-022.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-112-000 token-112-001 token-112-002 token-112-003 token-112-004 token-112-005 token-112-006 token-112-007 token-112-008 token-112-009 token-112-010 token-112-011 token-112-012 token-112-013 token-112-014 token-112-015 token-112-016 token-112-017 token-112-018 token-112-019 token-112-020 token-112-021 token-112-022 token-112-023 token-112-024 token-112-025 token-112-026 token-112-027 token-112-028 token-112-029 token-112-030 token-112-031 token-112-032 token-112-033 token-112-034 token-112-035 token-112-036 token-112-037 token-112-038 token-112-039 token-112-040 token-112-041 token-112-042 token-112-043 token-112-044 token-112-045 token-112-046 token-112-047
