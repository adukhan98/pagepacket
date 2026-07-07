# note 018

Owner: sanitized-owner-048@example.test
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
pagepacket-cli snapshot . product/research/note-018.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-048-000 token-048-001 token-048-002 token-048-003 token-048-004 token-048-005 token-048-006 token-048-007 token-048-008 token-048-009 token-048-010 token-048-011 token-048-012 token-048-013 token-048-014 token-048-015 token-048-016 token-048-017 token-048-018 token-048-019 token-048-020 token-048-021 token-048-022 token-048-023 token-048-024 token-048-025 token-048-026 token-048-027 token-048-028 token-048-029 token-048-030 token-048-031 token-048-032 token-048-033 token-048-034 token-048-035 token-048-036 token-048-037 token-048-038 token-048-039 token-048-040 token-048-041 token-048-042 token-048-043 token-048-044 token-048-045 token-048-046 token-048-047
