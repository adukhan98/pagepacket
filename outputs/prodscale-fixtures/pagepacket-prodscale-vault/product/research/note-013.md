# note 013

Owner: sanitized-owner-043@example.test
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
pagepacket-cli snapshot . product/research/note-013.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-043-000 token-043-001 token-043-002 token-043-003 token-043-004 token-043-005 token-043-006 token-043-007 token-043-008 token-043-009 token-043-010 token-043-011 token-043-012 token-043-013 token-043-014 token-043-015 token-043-016 token-043-017 token-043-018 token-043-019 token-043-020 token-043-021 token-043-022 token-043-023 token-043-024 token-043-025 token-043-026 token-043-027 token-043-028 token-043-029 token-043-030 token-043-031 token-043-032 token-043-033 token-043-034 token-043-035 token-043-036 token-043-037 token-043-038 token-043-039 token-043-040 token-043-041 token-043-042 token-043-043 token-043-044 token-043-045 token-043-046 token-043-047
