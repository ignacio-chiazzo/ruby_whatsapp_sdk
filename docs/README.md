# Ruby WhatsApp SDK Documentation

This directory contains the Docusaurus documentation website for the Ruby WhatsApp SDK.

## 🚀 Quick Start

### Prerequisites

- Node.js 18 or higher
- npm

### Installation

```bash
cd docs
npm install
```

### Local Development

```bash
npm start
```

This command starts a local development server and opens a browser window. Most changes are reflected live without having to restart the server.

### Build

```bash
npm run build
```

This command generates static content into the `build` directory that can be served using any static content hosting service.

### Serve Locally

```bash
npm run serve
```

Serves the built website locally to test the production build.

## 📁 Project Structure

```
docs/
├── docs/                  # Documentation markdown files
│   ├── intro.md          # Getting started guide
│   ├── api/              # API reference documentation
│   │   ├── messages.md   # Messages API
│   │   ├── media.md      # Media API
│   │   ├── templates.md  # Templates API
│   │   ├── phone-numbers.md
│   │   └── business-profile.md
│   ├── configuration.md  # Configuration guide
│   ├── examples.md       # Code examples
│   └── troubleshooting.md
├── blog/                 # Blog posts (optional)
├── src/                  # React components and custom pages
├── static/               # Static assets
├── docusaurus.config.ts  # Docusaurus configuration
├── sidebars.ts          # Sidebar navigation
└── package.json
```

## ✏️ Contributing to Documentation

### Adding New Pages

1. Create a new markdown file in the `docs/` directory
2. Add frontmatter with `sidebar_position` to control ordering
3. Update `sidebars.ts` if needed for custom navigation

Example:
```markdown
---
sidebar_position: 3
---

# New Page Title

Content goes here...
```

### API Documentation

API documentation follows this structure:
- **Overview** - Brief description of the API
- **Basic Usage** - Simple examples
- **Advanced Usage** - Complex scenarios
- **Error Handling** - Common errors and solutions
- **Best Practices** - Recommendations
- **Next Steps** - Links to related pages

### Code Examples

- Use proper language syntax highlighting
- Include complete, working examples
- Add comments to explain complex logic
- Show both success and error handling

## 🚀 Deployment

The documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch.

### Manual Deployment

For manual deployment to GitHub Pages:

```bash
USE_SSH=true npm run deploy
```

### Deployment Configuration

The site is configured for deployment at:
- **URL**: `https://ignacio-chiazzo.github.io`
- **Base URL**: `/ruby_whatsapp_sdk/`

## 🛠️ Configuration

Key configuration files:

- `docusaurus.config.ts` - Main Docusaurus configuration
- `sidebars.ts` - Navigation sidebar structure
- `.github/workflows/deploy-docs.yml` - Automated deployment

## 📝 Writing Guidelines

1. **Clear and Concise**: Write in simple, clear language
2. **Code Examples**: Include practical, working examples
3. **Error Handling**: Always show how to handle errors
4. **Best Practices**: Include recommendations and warnings
5. **Cross-references**: Link to related documentation
6. **Up-to-date**: Keep examples current with the latest API

## 🔗 Useful Links

- [Docusaurus Documentation](https://docusaurus.io/)
- [Markdown Features](https://docusaurus.io/docs/markdown-features)
- [Ruby WhatsApp SDK GitHub](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk)
- [WhatsApp Cloud API Docs](https://developers.facebook.com/docs/whatsapp/cloud-api)

## 📞 Support

For documentation issues:
1. Check existing [GitHub Issues](https://github.com/ignacio-chiazzo/ruby_whatsapp_sdk/issues)
2. Create a new issue with the `documentation` label
3. Provide specific details about what's unclear or missing