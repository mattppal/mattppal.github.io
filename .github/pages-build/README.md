# GitHub Pages Build Action

This Action can programmatically rebuild your GitHub Page by hitting the API endpoint and requesting a build. This can be helpful when your Page references changing, external data, but the Page only picks up these changes when it's rebuilt.

## Inputs

### `username`
**Required** The GitHub username of the associated GitHub Page

### `api_token`
**Required** The GitHub API token used for making authenticated calls

## Example usage

```
uses: xsalazar/actions/pages-build@master
with:
  username: ${{ github.actor }}
  api_token: ${{ secrets.API_TOKEN }}
```
