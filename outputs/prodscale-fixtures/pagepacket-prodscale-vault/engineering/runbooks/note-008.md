# note 008

Owner: sanitized-owner-098@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-008.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-098-000 token-098-001 token-098-002 token-098-003 token-098-004 token-098-005 token-098-006 token-098-007 token-098-008 token-098-009 token-098-010 token-098-011 token-098-012 token-098-013 token-098-014 token-098-015 token-098-016 token-098-017 token-098-018 token-098-019 token-098-020 token-098-021 token-098-022 token-098-023 token-098-024 token-098-025 token-098-026 token-098-027 token-098-028 token-098-029 token-098-030 token-098-031 token-098-032 token-098-033 token-098-034 token-098-035 token-098-036 token-098-037 token-098-038 token-098-039 token-098-040 token-098-041 token-098-042 token-098-043 token-098-044 token-098-045 token-098-046 token-098-047
