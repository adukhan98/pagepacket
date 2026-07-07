# note 030

Owner: sanitized-owner-120@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-120-000 token-120-001 token-120-002 token-120-003 token-120-004 token-120-005 token-120-006 token-120-007 token-120-008 token-120-009 token-120-010 token-120-011 token-120-012 token-120-013 token-120-014 token-120-015 token-120-016 token-120-017 token-120-018 token-120-019 token-120-020 token-120-021 token-120-022 token-120-023 token-120-024 token-120-025 token-120-026 token-120-027 token-120-028 token-120-029 token-120-030 token-120-031 token-120-032 token-120-033 token-120-034 token-120-035 token-120-036 token-120-037 token-120-038 token-120-039 token-120-040 token-120-041 token-120-042 token-120-043 token-120-044 token-120-045 token-120-046 token-120-047
