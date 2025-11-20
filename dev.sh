#!/usr/bin/env bash
(cd backend && ./dev.sh)&
(cd frontend && ./start.sh)&
wait
