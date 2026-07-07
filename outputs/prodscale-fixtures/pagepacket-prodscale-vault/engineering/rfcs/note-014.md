# note 014

Owner: sanitized-owner-074@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-014.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-074-000 token-074-001 token-074-002 token-074-003 token-074-004 token-074-005 token-074-006 token-074-007 token-074-008 token-074-009 token-074-010 token-074-011 token-074-012 token-074-013 token-074-014 token-074-015 token-074-016 token-074-017 token-074-018 token-074-019 token-074-020 token-074-021 token-074-022 token-074-023 token-074-024 token-074-025 token-074-026 token-074-027 token-074-028 token-074-029 token-074-030 token-074-031 token-074-032 token-074-033 token-074-034 token-074-035 token-074-036 token-074-037 token-074-038 token-074-039 token-074-040 token-074-041 token-074-042 token-074-043 token-074-044 token-074-045 token-074-046 token-074-047
