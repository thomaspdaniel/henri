# Freeplane Mind Map Creation Protocol

## Purpose
This protocol provides the XML structure specifications and style guidelines for creating, modifying, and validating Freeplane mind map files (.mm extension).

## When This Protocol Applies
Trigger this protocol when the user mentions:
- "freeplane file"
- "mind map"
- "create freeplane"
- "modify freeplane"
- "look at this freeplane file"
- "change this freeplane file"

## Freeplane File Format Specifications

### Basic XML Structure
All Freeplane files must start with XML declaration and follow this root structure:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<map version="freeplane 1.11.5">
  <node TEXT="Root Node" ID="ID_ROOT">
    <!-- Child nodes here -->
  </node>
</map>
```

### Node Structure and Attributes

#### Essential Node Attributes
- `TEXT`: Node text content (required)
- `ID`: Unique node identifier (required for root, optional for others)
- `POSITION`: Node position relative to parent ("left" or "right")
- `FOLDED`: Whether node is collapsed ("true" or "false")
- `CREATED`: Creation timestamp (milliseconds since epoch)
- `MODIFIED`: Modification timestamp (milliseconds since epoch)

#### Visual Styling Attributes
- `BACKGROUND_COLOR`: Hex color code (e.g., "#EEEEEE")
- `COLOR`: Text color as hex code
- `LINK`: Hyperlink URL or internal node reference
- `STYLE`: Node shape style - **ALWAYS use "bubble"** for consistent appearance

#### Node Shape Standard
**All nodes should use `STYLE="bubble"`** for a clean, modern appearance. This is the required standard for all mind maps.

#### Example Node with Styling
```xml
<node TEXT="Sample Node"
      ID="ID_123456789"
      STYLE="bubble"
      BACKGROUND_COLOR="#FFE6CC"
      COLOR="#000000"
      FOLDED="false">
  <font NAME="SansSerif" SIZE="12" BOLD="true"/>
  <icon BUILTIN="idea"/>
</node>
```

### Child Elements

#### Font Formatting
```xml
<font NAME="SansSerif" SIZE="12" BOLD="true" ITALIC="false"/>
```
- `NAME`: Font family (SansSerif, Serif, Monospaced, Dialog)
- `SIZE`: Font size in points
- `BOLD`: "true" or "false"
- `ITALIC`: "true" or "false"

#### Icons
```xml
<icon BUILTIN="icon_name"/>
```
Common built-in icons:
- `idea` - Light bulb
- `yes` - Green checkmark
- `no` - Red X
- `help` - Question mark
- `button_ok` - OK button
- `button_cancel` - Cancel button
- `info` - Information icon
- `messagebox_warning` - Warning triangle

#### Edge (Connection Line) Styling
```xml
<edge COLOR="#808080" WIDTH="2" STYLE="bezier"/>
```
- `COLOR`: Line color as hex code
- `WIDTH`: Line width in pixels
- `STYLE`: "linear", "bezier", "sharp_linear", "sharp_bezier"

#### Rich Content (HTML)
```xml
<richcontent TYPE="NODE">
  <html>
    <head></head>
    <body>
      <p>Rich text content with <b>bold</b> and <i>italic</i></p>
    </body>
  </html>
</richcontent>
```

#### Cloud Background
```xml
<cloud COLOR="#F0F0F0" SHAPE="ROUND_RECT"/>
```

#### Custom Attributes
```xml
<attribute NAME="key" VALUE="value"/>
```

### Node Nesting
Nodes can be nested to any depth:

```xml
<node TEXT="Parent">
  <node TEXT="Child 1">
    <node TEXT="Grandchild 1"/>
    <node TEXT="Grandchild 2"/>
  </node>
  <node TEXT="Child 2"/>
</node>
```

## Style Guide for Mind Maps

### Color Scheme Standards

#### Agent Type Color Coding
Use consistent colors to represent different agent types in orchestration workflows:

- **Agent Orchestrator**: `#E6F3FF` (Light Blue) - Planning/design phase
- **Orchestrator Agent**: `#FFE6F0` (Light Pink) - Coordination/management
- **Do'er Agents**: `#E6FFE6` (Light Green) - Execution work
- **Verifier Agents**: `#FFF9E6` (Light Yellow) - Validation/review
- **Archival Agent**: `#F0E6FF` (Light Purple) - Cleanup/maintenance

#### Process Phase Color Coding
- **Planning Phase**: `#CCE5FF` (Blue)
- **Execution Phase**: `#CCFFCC` (Green)
- **Verification Phase**: `#FFFFCC` (Yellow)
- **Completion Phase**: `#E6CCFF` (Purple)
- **Error/Blocked States**: `#FFCCCC` (Red)

#### Status Color Coding
- **Pending**: `#E0E0E0` (Light Gray)
- **In Progress**: `#CCE5FF` (Light Blue)
- **Completed**: `#CCFFCC` (Light Green)
- **Blocked**: `#FFCCCC` (Light Red)
- **Verified**: `#CCFFDD` (Pale Green)

### Icon Usage Standards

#### Process Flow Icons
- Use `button_ok` for completed steps
- Use `button_cancel` for blocked/failed steps
- Use `help` for questions or clarifications needed
- Use `messagebox_warning` for validation checkpoints
- Use `info` for important notes or context

#### Agent Type Icons
- Use `idea` for orchestrator/planning agents
- Use `yes` for verifier agents (validation)
- Use `help` for agents requiring user input

### Structural Organization

#### Hierarchical Depth
- **Level 0 (Root)**: Overall system/workflow name
- **Level 1**: Major phases or agent types
- **Level 2**: Specific agents or process steps
- **Level 3**: Agent responsibilities or substeps
- **Level 4+**: Detailed notes, validation points, success criteria

#### Node Text Guidelines
- Keep node text concise (< 60 characters preferred)
- Use rich content for longer descriptions
- Use proper capitalization (Title Case for major nodes, Sentence case for details)
- Avoid redundant prefixes when hierarchy makes context clear

#### Layout Strategy
- Use `POSITION="right"` for forward flow (what happens next)
- Use `POSITION="left"` for supporting information (context, notes, dependencies)
- Group related nodes together visually

### Template Structures

#### Agent Workflow Template
```xml
<node TEXT="Workflow Name" ID="ID_ROOT" STYLE="bubble" BACKGROUND_COLOR="#E6F3FF">
  <node TEXT="Planning Phase" POSITION="right" STYLE="bubble" BACKGROUND_COLOR="#CCE5FF">
    <node TEXT="Agent Name" STYLE="bubble" BACKGROUND_COLOR="#E6F3FF">
      <icon BUILTIN="idea"/>
      <node TEXT="Responsibilities" STYLE="bubble"/>
      <node TEXT="Inputs Required" STYLE="bubble"/>
      <node TEXT="Outputs Produced" STYLE="bubble"/>
    </node>
  </node>
  <node TEXT="Execution Phase" POSITION="right" STYLE="bubble" BACKGROUND_COLOR="#CCFFCC">
    <!-- Do'er agents here -->
  </node>
  <node TEXT="Verification Phase" POSITION="right" STYLE="bubble" BACKGROUND_COLOR="#FFFFCC">
    <!-- Verifier agents here -->
  </node>
</node>
```

#### Validation Checkpoint Template
```xml
<node TEXT="Validation Checkpoint" STYLE="bubble" BACKGROUND_COLOR="#FFF9E6">
  <icon BUILTIN="messagebox_warning"/>
  <node TEXT="What is validated" STYLE="bubble"/>
  <node TEXT="Success criteria" STYLE="bubble"/>
  <node TEXT="Failure handling" STYLE="bubble"/>
</node>
```

## File Naming Conventions

### Standard Format
`[project]_[purpose]_[date].mm`

Examples:
- `orchestration_workflow_20250930.mm`
- `henri_agent_flow_20250930.mm`
- `requirements_categorization_process_20250930.mm`

### Version Control
- Store Freeplane files in version control
- Include in project documentation directories
- Update modification dates in XML when editing

## Validation Checklist

When creating or modifying Freeplane files:

- [ ] XML declaration present: `<?xml version="1.0" encoding="UTF-8"?>`
- [ ] Root `<map>` element with version attribute
- [ ] Root node has `TEXT` and `ID` attributes
- [ ] **All nodes have `STYLE="bubble"` attribute**
- [ ] All nodes properly closed
- [ ] Color codes are valid hex format
- [ ] Icon names match built-in icon set
- [ ] File saved with `.mm` extension
- [ ] UTF-8 encoding maintained
- [ ] Proper XML escaping for special characters (&, <, >, ", ')

## Special Characters Handling

XML requires escaping special characters in text content:
- `&` → `&amp;`
- `<` → `&lt;`
- `>` → `&gt;`
- `"` → `&quot;`
- `'` → `&apos;`

## Best Practices

1. **Start Simple**: Begin with basic structure, add styling incrementally
2. **Consistent IDs**: Use descriptive ID patterns (e.g., `ID_AGENT_ORCHESTRATOR`)
3. **Color Purposefully**: Colors should convey meaning, not just aesthetics
4. **Test in Freeplane**: Validate generated files open correctly in Freeplane
5. **Version Control**: Track changes to mind maps like code
6. **Document Intent**: Use notes/rich content to explain complex relationships
7. **Minimize Clutter**: Don't over-style; clarity over decoration

## Common Issues and Solutions

### Issue: File Won't Open in Freeplane
- Check XML is well-formed (all tags closed)
- Verify XML declaration is first line
- Ensure encoding is UTF-8
- Check for unescaped special characters

### Issue: Colors Not Displaying
- Verify hex color format includes `#` prefix
- Use 6-digit hex codes (not 3-digit shortcuts)
- Check attribute spelling: `BACKGROUND_COLOR` not `BGCOLOR`

### Issue: Icons Not Showing
- Use exact built-in icon names (case-sensitive)
- Check icon element: `<icon BUILTIN="name"/>`
- Verify icon name exists in Freeplane's icon set

## Reference Resources

- Freeplane Official Documentation: https://docs.freeplane.org/
- Current File Format Spec: https://docs.freeplane.org/attic/old-mediawiki-content/Current_Freeplane_File_Format.html
- Built-in Icons List: Available in Freeplane GUI under Insert → Icons

## Change Log
- **2025-10-17** - Added Change Log section to comply with protocol authoring standards (Tom - Project Owner)
- **2024-09-30** - Initial creation with comprehensive Freeplane XML specifications and style guide (Tom - Project Owner)
