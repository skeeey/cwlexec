#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo

requirements:
  - class: InlineJavascriptRequirement

inputs:
    - id: "a2"
      type:
        type: array
        items: string
        inputBinding:
            prefix: -a2
      inputBinding:
        position: -1
      default:
        - "a"
        - "b"
    - id: "a1"
      type:
        type: array
        items: string
        inputBinding:
            prefix: -a1
      inputBinding:
        position: -1
      default:
        - "c"
        - "d"
    - id: "a3"
      type: string
      inputBinding:
        position: 6
      default: "test"
outputs: []
arguments:
    - prefix: -k
      valueFrom: "a1"
      position: -1
    - prefix: -B
      valueFrom: $("/foo/bar/baz".split('/').slice(-1)[0])
    - prefix: -C
      valueFrom: |
        ${
            var r = [];
            for (var i = 10; i >= 1; i--) {
                r.push(i);
            }
            return r;
        }
