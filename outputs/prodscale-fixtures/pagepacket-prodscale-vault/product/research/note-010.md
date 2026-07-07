# note 010

Owner: sanitized-owner-040@example.test
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
pagepacket-cli snapshot . product/research/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-040-000 token-040-001 token-040-002 token-040-003 token-040-004 token-040-005 token-040-006 token-040-007 token-040-008 token-040-009 token-040-010 token-040-011 token-040-012 token-040-013 token-040-014 token-040-015 token-040-016 token-040-017 token-040-018 token-040-019 token-040-020 token-040-021 token-040-022 token-040-023 token-040-024 token-040-025 token-040-026 token-040-027 token-040-028 token-040-029 token-040-030 token-040-031 token-040-032 token-040-033 token-040-034 token-040-035 token-040-036 token-040-037 token-040-038 token-040-039 token-040-040 token-040-041 token-040-042 token-040-043 token-040-044 token-040-045 token-040-046 token-040-047
