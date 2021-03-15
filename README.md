# tag_dist_artifact
Action to build and tag the distributable files of a repository

## Inputs

### `tag_version`

**Required** The number of the version to assign the release. Eg `"v0.0.1"`.

## Outputs

### `time`

The time we greeted you.

## Example usage

uses: actions/tag-dist-artifact@v1
with:
  tag_version: ${{ steps.tag_version.outputs.new_tag }}