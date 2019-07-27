cwlVersion: v1.0
$graph:
- id: main
  class: Workflow
  requirements:
    - class: InlineJavascriptRequirement

  inputs:
    app_name: string
    class_name: string

  outputs:
    binary:
      type: File
      outputSource: jar/jar_file

  steps:
    tar:
      run: "#tar"
      in:
        tarball_name:
          source: app_name
          valueFrom: $(self + '-src.tar')
        file_name: 
          source: class_name
          valueFrom: $(self + '.java')
      out: [tarball]

    compile:
      run: "1st-workflow.cwl"
      in:
        inp: tar/tarball
        ex:
          source: class_name
          valueFrom: $(self + '.java')
      out: [classout]

    jar:
      run: "#jar"
      in:
        jar_file_name:
          source: app_name
          valueFrom: $(self + '-bin.jar')
        cwd: compile/classout
        class_file: compile/classout
      out: [jar_file]

- id: tar
  class: CommandLineTool
  requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.file_name)
        entry: |
          public class $(inputs.file_name.split('.')[0]) {
              public static void main(String[] args) {
                System.out.println("Hello!");
              }
          }
  baseCommand: [tar, cf]
  inputs:
    tarball_name:
      type: string
      inputBinding:
        position: 1
    file_name:
      type: string
      inputBinding:
        position: 2
  outputs:
    tarball:
      type: File
      outputBinding:
        glob: "*.tar"

- id: jar
  class: CommandLineTool
  baseCommand: [jar, cf]
  inputs:
    jar_file_name:
      type: string
      inputBinding:
        position: 1
    cwd:
      type: File
      inputBinding:
        prefix: -C
        position: 2
        valueFrom: $(self.dirname)
    class_file:
      type: File
      inputBinding:
        position: 3
        valueFrom: $(self.basename)
  outputs:
    jar_file:
      type: File
      outputBinding:
        glob: "*.jar"