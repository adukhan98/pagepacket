# note 023

Owner: sanitized-owner-083@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-023.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-083-000 token-083-001 token-083-002 token-083-003 token-083-004 token-083-005 token-083-006 token-083-007 token-083-008 token-083-009 token-083-010 token-083-011 token-083-012 token-083-013 token-083-014 token-083-015 token-083-016 token-083-017 token-083-018 token-083-019 token-083-020 token-083-021 token-083-022 token-083-023 token-083-024 token-083-025 token-083-026 token-083-027 token-083-028 token-083-029 token-083-030 token-083-031 token-083-032 token-083-033 token-083-034 token-083-035 token-083-036 token-083-037 token-083-038 token-083-039 token-083-040 token-083-041 token-083-042 token-083-043 token-083-044 token-083-045 token-083-046 token-083-047
