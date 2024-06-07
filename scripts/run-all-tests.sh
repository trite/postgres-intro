#!/bin/bash

# TODO: this is a terrible way of doing things, but it's fine for now for a POC

cram tests/restricted-user-access-expectations.t
cram tests/powerful-user-access-expectations.t
