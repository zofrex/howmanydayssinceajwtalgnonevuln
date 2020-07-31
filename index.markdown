---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

{% assign latest_vuln = site.data.vulns | sort: "date" | last %}

<h1>It has been {{ latest_vuln.date | since }} since the last alg=none JWT vulnerability</h1>

<p>{{ latest_vuln.description }}</p>
