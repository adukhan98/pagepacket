# note 029

Owner: sanitized-owner-239@example.test
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
pagepacket-cli snapshot . knowledge/base/note-029.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-239-000 token-239-001 token-239-002 token-239-003 token-239-004 token-239-005 token-239-006 token-239-007 token-239-008 token-239-009 token-239-010 token-239-011 token-239-012 token-239-013 token-239-014 token-239-015 token-239-016 token-239-017 token-239-018 token-239-019 token-239-020 token-239-021 token-239-022 token-239-023 token-239-024 token-239-025 token-239-026 token-239-027 token-239-028 token-239-029 token-239-030 token-239-031 token-239-032 token-239-033 token-239-034 token-239-035 token-239-036 token-239-037 token-239-038 token-239-039 token-239-040 token-239-041 token-239-042 token-239-043 token-239-044 token-239-045 token-239-046 token-239-047
