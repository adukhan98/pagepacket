# note 030

Owner: sanitized-owner-300@example.test
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
pagepacket-cli snapshot . archive/2025/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-300-000 token-300-001 token-300-002 token-300-003 token-300-004 token-300-005 token-300-006 token-300-007 token-300-008 token-300-009 token-300-010 token-300-011 token-300-012 token-300-013 token-300-014 token-300-015 token-300-016 token-300-017 token-300-018 token-300-019 token-300-020 token-300-021 token-300-022 token-300-023 token-300-024 token-300-025 token-300-026 token-300-027 token-300-028 token-300-029 token-300-030 token-300-031 token-300-032 token-300-033 token-300-034 token-300-035 token-300-036 token-300-037 token-300-038 token-300-039 token-300-040 token-300-041 token-300-042 token-300-043 token-300-044 token-300-045 token-300-046 token-300-047
