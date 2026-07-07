# note 020

Owner: sanitized-owner-350@example.test
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
pagepacket-cli snapshot . drafts/note-020.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-350-000 token-350-001 token-350-002 token-350-003 token-350-004 token-350-005 token-350-006 token-350-007 token-350-008 token-350-009 token-350-010 token-350-011 token-350-012 token-350-013 token-350-014 token-350-015 token-350-016 token-350-017 token-350-018 token-350-019 token-350-020 token-350-021 token-350-022 token-350-023 token-350-024 token-350-025 token-350-026 token-350-027 token-350-028 token-350-029 token-350-030 token-350-031 token-350-032 token-350-033 token-350-034 token-350-035 token-350-036 token-350-037 token-350-038 token-350-039 token-350-040 token-350-041 token-350-042 token-350-043 token-350-044 token-350-045 token-350-046 token-350-047
