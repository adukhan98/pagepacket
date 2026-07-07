# note 003

Owner: sanitized-owner-033@example.test
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
pagepacket-cli snapshot . product/research/note-003.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-033-000 token-033-001 token-033-002 token-033-003 token-033-004 token-033-005 token-033-006 token-033-007 token-033-008 token-033-009 token-033-010 token-033-011 token-033-012 token-033-013 token-033-014 token-033-015 token-033-016 token-033-017 token-033-018 token-033-019 token-033-020 token-033-021 token-033-022 token-033-023 token-033-024 token-033-025 token-033-026 token-033-027 token-033-028 token-033-029 token-033-030 token-033-031 token-033-032 token-033-033 token-033-034 token-033-035 token-033-036 token-033-037 token-033-038 token-033-039 token-033-040 token-033-041 token-033-042 token-033-043 token-033-044 token-033-045 token-033-046 token-033-047
