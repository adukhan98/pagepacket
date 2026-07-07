# note 001

Owner: sanitized-owner-061@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-001.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-061-000 token-061-001 token-061-002 token-061-003 token-061-004 token-061-005 token-061-006 token-061-007 token-061-008 token-061-009 token-061-010 token-061-011 token-061-012 token-061-013 token-061-014 token-061-015 token-061-016 token-061-017 token-061-018 token-061-019 token-061-020 token-061-021 token-061-022 token-061-023 token-061-024 token-061-025 token-061-026 token-061-027 token-061-028 token-061-029 token-061-030 token-061-031 token-061-032 token-061-033 token-061-034 token-061-035 token-061-036 token-061-037 token-061-038 token-061-039 token-061-040 token-061-041 token-061-042 token-061-043 token-061-044 token-061-045 token-061-046 token-061-047
