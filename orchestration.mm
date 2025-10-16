<map version="freeplane 1.12.1">
<!--To view this file, download free mind mapping software Freeplane from https://www.freeplane.org -->
<bookmarks>
    <bookmark nodeId="ID_ROOT" name="Root" opensAsRoot="true"/>
</bookmarks>
<node STYLE="bubble" TEXT="Orchestration System" FOLDED="false" ID="ID_ROOT" CREATED="1759714995110" MODIFIED="1759714995110" BACKGROUND_COLOR="#ffffff">
<font NAME="SansSerif" SIZE="14" BOLD="true"/>
<hook NAME="MapStyle" zoom="2.0">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" auto_compact_layout="true" fit_to_viewport="false" show_icons="BESIDE_NODES" show_icon_for_attributes="true" show_tags="UNDER_NODES" showTagCategories="false" show_note_icons="true"/>
    <tags category_separator="::"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ID="ID_271890427" ICON_SIZE="12 pt" COLOR="#000000" STYLE="fork">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" DASH="" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_271890427" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
<richcontent TYPE="DETAILS" CONTENT-TYPE="plain/auto"/>
<richcontent TYPE="NOTE" CONTENT-TYPE="plain/auto"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.tags">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.selection" BACKGROUND_COLOR="#afd3f7" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#afd3f7"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important" ID="ID_67550811">
<icon BUILTIN="yes"/>
<arrowlink COLOR="#003399" TRANSPARENCY="255" DESTINATION="ID_67550811"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.flower" COLOR="#ffffff" BACKGROUND_COLOR="#255aba" STYLE="oval" TEXT_ALIGN="CENTER" BORDER_WIDTH_LIKE_EDGE="false" BORDER_WIDTH="22 pt" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#f9d71c" BORDER_DASH_LIKE_EDGE="false" BORDER_DASH="CLOSE_DOTS" MAX_WIDTH="6 cm" MIN_WIDTH="3 cm"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10 pt" SHAPE_VERTICAL_MARGIN="10 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<node STYLE="bubble" TEXT="Workflow Lifecycle" FOLDED="true" POSITION="bottom_or_right" ID="ID_450031907" CREATED="1759714995110" MODIFIED="1759714995110" BACKGROUND_COLOR="#cce5ff">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="1. Plan Development" ID="ID_667318599" CREATED="1759714995110" MODIFIED="1759714995110" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="User works with default Claude agent" ID="ID_1013696543" CREATED="1759714995110" MODIFIED="1759714995110"/>
<node STYLE="bubble" TEXT="Develop rough plan with context" ID="ID_564307987" CREATED="1759714995110" MODIFIED="1759714995110"/>
<node STYLE="bubble" TEXT="Capture whats and whys" ID="ID_871423273" CREATED="1759714995110" MODIFIED="1759714995110"/>
</node>
<node STYLE="bubble" TEXT="2. Conversation Summary" ID="ID_795640395" CREATED="1759714995110" MODIFIED="1759714995110" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Document: conversation_summary_[taskname].md" ID="ID_1940834609" CREATED="1759714995110" MODIFIED="1759714995110"/>
<node STYLE="bubble" TEXT="Contains: goals, decisions, constraints, open items" ID="ID_490586635" CREATED="1759714995110" MODIFIED="1759714995110"/>
<node STYLE="bubble" TEXT="Input for Workflow Architect" ID="ID_1963809880" CREATED="1759714995110" MODIFIED="1759714995110"/>
</node>
<node STYLE="bubble" TEXT="3. Workflow Design" ID="ID_768484840" CREATED="1759714995110" MODIFIED="1759714995110" BACKGROUND_COLOR="#e6f3ff">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="User manually activates Workflow Architect" ID="ID_1652078716" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="Architect reads summary and asks questions" ID="ID_1500365237" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="Designs multi-agent workflow" ID="ID_388274960" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="May spawn sub-agents for complex workflows" ID="ID_245221259" CREATED="1759714995112" MODIFIED="1759714995112">
<node STYLE="bubble" TEXT="Instruction Writer Agent" ID="ID_861287422" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="File Structure Designer" ID="ID_1762656347" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="Validation Checkpoint Designer" ID="ID_684773654" CREATED="1759714995112" MODIFIED="1759714995112"/>
</node>
<node STYLE="bubble" TEXT="Produces workflow_coordination_plan.md" ID="ID_1749528051" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="Creates agent_instructions.md for each agent" ID="ID_329890259" CREATED="1759714995112" MODIFIED="1759714995112"/>
</node>
<node STYLE="bubble" TEXT="4. Design Verification" ID="ID_901879716" CREATED="1759714995112" MODIFIED="1759714995112" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="messagebox_warning"/>
<node STYLE="bubble" TEXT="Design Verifier Agent reviews workflow design" ID="ID_1928961965" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="Checks completeness and consistency" ID="ID_1711323871" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="Validates before execution begins" ID="ID_50799493" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="If gaps found: Architect addresses issues" ID="ID_1960260382" CREATED="1759714995112" MODIFIED="1759714995112"/>
<node STYLE="bubble" TEXT="User makes final approval decision" ID="ID_124190122" CREATED="1759714995112" MODIFIED="1759714995112"/>
</node>
<node STYLE="bubble" TEXT="5. Workflow Execution" ID="ID_1372265895" CREATED="1759714995114" MODIFIED="1759714995114" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Workflow Executor coordinates agents" ID="ID_271591915" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Follows sequencing plan from Architecture Group" ID="ID_1719170021" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Turn-based execution model" ID="ID_1707524595" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Monitors escalations and blockages" ID="ID_1344829505" CREATED="1759714995115" MODIFIED="1759714995115"/>
</node>
<node STYLE="bubble" TEXT="6. Agent Work Phase" ID="ID_312292340" CREATED="1759714995115" MODIFIED="1759714995115" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Do&apos;er agents perform assigned work" ID="ID_1933247530" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Track completion drive notes" ID="ID_174172963" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Update shared_status.json" ID="ID_1379142505" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Write outputs to task_output/ directory" ID="ID_1069532613" CREATED="1759714995115" MODIFIED="1759714995115"/>
</node>
<node STYLE="bubble" TEXT="7. Completion Drive Review" ID="ID_1716736162" CREATED="1759714995115" MODIFIED="1759714995115" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="messagebox_warning"/>
<node STYLE="bubble" TEXT="Agent reviews all completion drive notes" ID="ID_555075487" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Resolves or escalates each note" ID="ID_647613771" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Cannot claim done until all notes addressed" ID="ID_35944058" CREATED="1759714995115" MODIFIED="1759714995115"/>
<node STYLE="bubble" TEXT="Status: working → completion_drive_review" ID="ID_1904144289" CREATED="1759714995117" MODIFIED="1759714995117"/>
</node>
<node STYLE="bubble" TEXT="8. Verification" ID="ID_1084485171" CREATED="1759714995117" MODIFIED="1759714995117" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="yes"/>
<node STYLE="bubble" TEXT="Status changes to ready_for_verification" ID="ID_399538725" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Verifier agent assigned" ID="ID_358421067" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Reviews work output AND completion drive" ID="ID_1552829547" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Success: Status → verified" ID="ID_1793426932" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Failure: Writes verification_results.json" ID="ID_1414859704" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Failed verification triggers rework cycle" ID="ID_1046038012" CREATED="1759714995117" MODIFIED="1759714995117"/>
</node>
<node STYLE="bubble" TEXT="9. Session Completion" ID="ID_1434011425" CREATED="1759714995117" MODIFIED="1759714995117" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="All agents verified" ID="ID_1008964946" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Workflow Executor signals complete" ID="ID_411574935" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Archival agent archives session files" ID="ID_1838434886" CREATED="1759714995117" MODIFIED="1759714995117"/>
<node STYLE="bubble" TEXT="Format: session_YYYYMMDD_HHMM_taskname.json" ID="ID_1749634595" CREATED="1759714995117" MODIFIED="1759714995117"/>
</node>
</node>
<node STYLE="bubble" TEXT="Agent Types" FOLDED="true" POSITION="bottom_or_right" ID="ID_513031110" CREATED="1759714995118" MODIFIED="1759714995118" BACKGROUND_COLOR="#e6f3ff">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="Workflow Architecture Group" ID="ID_1720144417" CREATED="1759714995120" MODIFIED="1759714995120" BACKGROUND_COLOR="#e6f3ff">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="Makes all workflow design decisions" ID="ID_503057083" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Routes all user questions/answers" ID="ID_46435518" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Updates workflow when answers change assumptions" ID="ID_158328785" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Workflow Architect" ID="ID_997187508" CREATED="1759714995120" MODIFIED="1759714995120" BACKGROUND_COLOR="#e6f3ff">
<node STYLE="bubble" TEXT="Analyzes conversation summaries" ID="ID_1602348248" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Asks clarifying questions" ID="ID_768449845" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Designs multi-agent workflows" ID="ID_518506490" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Critical Analysis" ID="ID_1316836501" CREATED="1759714995120" MODIFIED="1759714995120">
<node STYLE="bubble" TEXT="Agent requirements identification" ID="ID_927292337" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="New agent creation guidance" ID="ID_271123448" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Validation checkpoints at handoffs" ID="ID_517926623" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Failure mode analysis" ID="ID_1783280029" CREATED="1759714995120" MODIFIED="1759714995120"/>
<node STYLE="bubble" TEXT="Dependency chains with ordering" ID="ID_701214684" CREATED="1759714995121" MODIFIED="1759714995121"/>
<node STYLE="bubble" TEXT="Success criteria definition" ID="ID_680639526" CREATED="1759714995121" MODIFIED="1759714995121"/>
</node>
<node STYLE="bubble" TEXT="Outputs" ID="ID_1299004905" CREATED="1759714995121" MODIFIED="1759714995121">
<node STYLE="bubble" TEXT="workflow_coordination_plan.md" ID="ID_182859268" CREATED="1759714995121" MODIFIED="1759714995121"/>
<node STYLE="bubble" TEXT="agent_instructions.md per agent" ID="ID_1690586340" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Initial shared_status.json" ID="ID_819680874" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Agent sequencing and parallelism plan" ID="ID_1628811538" CREATED="1759714995123" MODIFIED="1759714995123"/>
</node>
<node STYLE="bubble" TEXT="Sub-Agent Delegation" ID="ID_130382561" CREATED="1759714995123" MODIFIED="1759714995123">
<node STYLE="bubble" TEXT="For complex workflows only" ID="ID_196109353" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Instruction Writer Agent" ID="ID_98572057" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="File Structure Designer" ID="ID_1686334138" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Validation Checkpoint Designer" ID="ID_271010837" CREATED="1759714995123" MODIFIED="1759714995123"/>
</node>
</node>
<node STYLE="bubble" TEXT="Design Verifier Agent" ID="ID_417532619" CREATED="1759714995123" MODIFIED="1759714995123" BACKGROUND_COLOR="#e6f3ff">
<node STYLE="bubble" TEXT="Reviews workflow design before execution" ID="ID_191880559" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Verification Checklist" ID="ID_1636608911" CREATED="1759714995123" MODIFIED="1759714995123">
<node STYLE="bubble" TEXT="Agent instructions completeness" ID="ID_646111011" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="File communication contracts" ID="ID_855866906" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Validation checkpoints" ID="ID_1279910771" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Dependency consistency" ID="ID_1247424002" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Task ID uniqueness" ID="ID_1214179877" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Escalation procedures" ID="ID_360736611" CREATED="1759714995123" MODIFIED="1759714995123"/>
<node STYLE="bubble" TEXT="Gap identification" ID="ID_730049003" CREATED="1759714995123" MODIFIED="1759714995123"/>
</node>
<node STYLE="bubble" TEXT="Produces verification report" ID="ID_497623918" CREATED="1759714995125" MODIFIED="1759714995125"/>
<node STYLE="bubble" TEXT="Flags gaps and inconsistencies" ID="ID_1148375425" CREATED="1759714995125" MODIFIED="1759714995125"/>
</node>
</node>
<node STYLE="bubble" TEXT="Workflow Executor" ID="ID_264987807" CREATED="1759714995125" MODIFIED="1759714995125" BACKGROUND_COLOR="#ffe6f0">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="Executes workflow plan (does not make sequencing decisions)" ID="ID_733283242" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Launches agents via Task tool" ID="ID_1946669322" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Monitors agent status and completion" ID="ID_1966735307" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Detects escalations (status: blocked)" ID="ID_1321841429" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Routes escalations to Architecture Group" ID="ID_915818629" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Updates completion drive notes with resolutions" ID="ID_1786110037" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Enforces completion drive gates" ID="ID_882152024" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Handles verification failures" ID="ID_779723293" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Implements retry logic (3 attempts on crash)" ID="ID_207912431" CREATED="1759714995126" MODIFIED="1759714995126"/>
<node STYLE="bubble" TEXT="Tracks verification failure count (5 max)" ID="ID_108790960" CREATED="1759714995126" MODIFIED="1759714995126"/>
</node>
<node STYLE="bubble" TEXT="Solution Architect Agent" ID="ID_1999766624" CREATED="1759714995126" MODIFIED="1759714995126" BACKGROUND_COLOR="#e6f3ff">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="Makes technical architecture decisions" ID="ID_1927098367" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Reviews architecture-related escalations" ID="ID_1695625012" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Handles escalated questions from do&apos;er agents" ID="ID_1967597573" CREATED="1759714995128" MODIFIED="1759714995128">
<node STYLE="bubble" TEXT="Technology/tool choices" ID="ID_627253967" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Architecture decisions" ID="ID_614355705" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Security decisions" ID="ID_94719823" CREATED="1759714995128" MODIFIED="1759714995128"/>
</node>
<node STYLE="bubble" TEXT="Works like do&apos;er agent" ID="ID_1050964133" CREATED="1759714995128" MODIFIED="1759714995128">
<node STYLE="bubble" TEXT="Has agent_instructions.md" ID="ID_926626472" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Has completion_drive/ directory" ID="ID_694653023" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Has task_output/ for decisions" ID="ID_85597800" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Goes through verification" ID="ID_1274974768" CREATED="1759714995128" MODIFIED="1759714995128"/>
</node>
</node>
<node STYLE="bubble" TEXT="Do&apos;er Agents" ID="ID_1077728278" CREATED="1759714995128" MODIFIED="1759714995128" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="Database Agent" ID="ID_162767837" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="API Agent" ID="ID_48278765" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Frontend Agent" ID="ID_1204943789" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Other specialized agents" ID="ID_164482065" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Responsibilities" ID="ID_268507352" CREATED="1759714995128" MODIFIED="1759714995128">
<node STYLE="bubble" TEXT="Perform assigned work" ID="ID_771765835" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Track completion drive notes" ID="ID_1519686842" CREATED="1759714995128" MODIFIED="1759714995128"/>
<node STYLE="bubble" TEXT="Update shared_status.json" ID="ID_1812125683" CREATED="1759714995130" MODIFIED="1759714995130"/>
<node STYLE="bubble" TEXT="Write outputs to task_output/" ID="ID_264056137" CREATED="1759714995130" MODIFIED="1759714995130"/>
<node STYLE="bubble" TEXT="Read upstream agent outputs" ID="ID_740066291" CREATED="1759714995130" MODIFIED="1759714995130"/>
<node STYLE="bubble" TEXT="Follow agent contract protocol" ID="ID_1303693998" CREATED="1759714995130" MODIFIED="1759714995130"/>
</node>
<node STYLE="bubble" TEXT="Escalation Rules" ID="ID_1941861377" CREATED="1759714995130" MODIFIED="1759714995130">
<node STYLE="bubble" TEXT="MUST ESCALATE" ID="ID_221206520" CREATED="1759714995130" MODIFIED="1759714995130">
<node STYLE="bubble" TEXT="Technology/tool choices" ID="ID_1312842125" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Architecture decisions" ID="ID_1212929832" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Security decisions" ID="ID_1184788187" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Requirements assumptions" ID="ID_1962218190" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Conflicting guidance" ID="ID_1709872645" CREATED="1759714995131" MODIFIED="1759714995131"/>
</node>
<node STYLE="bubble" TEXT="CAN SELF-RESOLVE" ID="ID_1893242602" CREATED="1759714995131" MODIFIED="1759714995131">
<node STYLE="bubble" TEXT="Code consistency fixes" ID="ID_1344787188" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Obvious bugs" ID="ID_1346283919" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Implementation details" ID="ID_1459111018" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Documentation improvements" ID="ID_194913915" CREATED="1759714995131" MODIFIED="1759714995131"/>
</node>
</node>
</node>
<node STYLE="bubble" TEXT="Verifier Agents" ID="ID_1314904609" CREATED="1759714995131" MODIFIED="1759714995131" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="yes"/>
<node STYLE="bubble" TEXT="Validate do&apos;er agent outputs" ID="ID_627569041" CREATED="1759714995131" MODIFIED="1759714995131"/>
<node STYLE="bubble" TEXT="Review completion drive resolution" ID="ID_1628279845" CREATED="1759714995133" MODIFIED="1759714995133"/>
<node STYLE="bubble" TEXT="Review work output AND notes" ID="ID_544697821" CREATED="1759714995133" MODIFIED="1759714995133"/>
<node STYLE="bubble" TEXT="Success: Status → verified" ID="ID_310259622" CREATED="1759714995133" MODIFIED="1759714995133"/>
<node STYLE="bubble" TEXT="Failure: Write verification_results.json" ID="ID_1193255049" CREATED="1759714995133" MODIFIED="1759714995133">
<node STYLE="bubble" TEXT="List missing evidence" ID="ID_834870250" CREATED="1759714995133" MODIFIED="1759714995133"/>
<node STYLE="bubble" TEXT="Return control to Workflow Executor" ID="ID_698472018" CREATED="1759714995133" MODIFIED="1759714995133"/>
</node>
<node STYLE="bubble" TEXT="Exit after writing feedback" ID="ID_573338426" CREATED="1759714995133" MODIFIED="1759714995133"/>
</node>
<node STYLE="bubble" TEXT="Archival Agent" ID="ID_1274297551" CREATED="1759714995133" MODIFIED="1759714995133" BACKGROUND_COLOR="#f0e6ff">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="Invoked by Workflow Architecture Group" ID="ID_1936148921" CREATED="1759714995133" MODIFIED="1759714995133"/>
<node STYLE="bubble" TEXT="Workflow Start" ID="ID_509507388" CREATED="1759714995134" MODIFIED="1759714995134">
<node STYLE="bubble" TEXT="Archive/remove stale session_current.json" ID="ID_1381991583" CREATED="1759714995134" MODIFIED="1759714995134"/>
<node STYLE="bubble" TEXT="Clean up crashed workflow artifacts" ID="ID_1759369563" CREATED="1759714995134" MODIFIED="1759714995134"/>
</node>
<node STYLE="bubble" TEXT="Workflow End" ID="ID_1560265065" CREATED="1759714995134" MODIFIED="1759714995134">
<node STYLE="bubble" TEXT="After all verifiers complete" ID="ID_1163587587" CREATED="1759714995134" MODIFIED="1759714995134"/>
<node STYLE="bubble" TEXT="Move session_current.json → archived format" ID="ID_1737801737" CREATED="1759714995134" MODIFIED="1759714995134"/>
<node STYLE="bubble" TEXT="Format: session_YYYYMMDD_HHMM_taskname.json" ID="ID_13168906" CREATED="1759714995134" MODIFIED="1759714995134"/>
</node>
<node STYLE="bubble" TEXT="Outputs" ID="ID_223176741" CREATED="1759714995134" MODIFIED="1759714995134">
<node STYLE="bubble" TEXT="cleanup_log.json" ID="ID_242648658" CREATED="1759714995135" MODIFIED="1759714995135"/>
<node STYLE="bubble" TEXT="archive_index.json" ID="ID_1171392379" CREATED="1759714995136" MODIFIED="1759714995136"/>
</node>
</node>
</node>
<node STYLE="bubble" TEXT="Coordination Mechanisms" POSITION="top_or_left" ID="ID_381429296" CREATED="1759714995137" MODIFIED="1759714995137" BACKGROUND_COLOR="#ccffcc">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="Turn-Based Execution Model" ID="ID_1871349696" CREATED="1759714995137" MODIFIED="1759714995137" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Workflow Executor launches agents via Task tool" ID="ID_384851691" CREATED="1759714995137" MODIFIED="1759714995137"/>
<node STYLE="bubble" TEXT="Task tool blocks until agent completes turn" ID="ID_1722493161" CREATED="1759714995137" MODIFIED="1759714995137"/>
<node STYLE="bubble" TEXT="Executor reads updated files after turn ends" ID="ID_901499976" CREATED="1759714995137" MODIFIED="1759714995137"/>
<node STYLE="bubble" TEXT="No real-time monitoring or polling" ID="ID_1984552397" CREATED="1759714995137" MODIFIED="1759714995137"/>
<node STYLE="bubble" TEXT="State changes detected at turn boundaries" ID="ID_1576945978" CREATED="1759714995137" MODIFIED="1759714995137"/>
<node STYLE="bubble" TEXT="When Turns End" ID="ID_1850045846" CREATED="1759714995137" MODIFIED="1759714995137">
<node STYLE="bubble" TEXT="Agent completes assigned work" ID="ID_1573851105" CREATED="1759714995137" MODIFIED="1759714995137"/>
<node STYLE="bubble" TEXT="Agent status changes to blocked" ID="ID_665463347" CREATED="1759714995138" MODIFIED="1759714995138"/>
<node STYLE="bubble" TEXT="Agent finishes completion drive review" ID="ID_193455922" CREATED="1759714995138" MODIFIED="1759714995138"/>
<node STYLE="bubble" TEXT="Agent completes verification" ID="ID_1080451714" CREATED="1759714995138" MODIFIED="1759714995138"/>
</node>
<node STYLE="bubble" TEXT="Agent Must" ID="ID_1829863361" CREATED="1759714995139" MODIFIED="1759714995139">
<node STYLE="bubble" TEXT="Update status in shared_status.json" ID="ID_39460516" CREATED="1759714995139" MODIFIED="1759714995139"/>
<node STYLE="bubble" TEXT="Write outputs to task_output/" ID="ID_208879670" CREATED="1759714995139" MODIFIED="1759714995139"/>
<node STYLE="bubble" TEXT="Update session_current.json" ID="ID_741049712" CREATED="1759714995139" MODIFIED="1759714995139"/>
<node STYLE="bubble" TEXT="Return control (Task completes)" ID="ID_129076152" CREATED="1759714995139" MODIFIED="1759714995139"/>
</node>
</node>
<node STYLE="bubble" TEXT="Escalation Resolution Protocol" ID="ID_500846893" CREATED="1759714995139" MODIFIED="1759714995139" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="messagebox_warning"/>
<node STYLE="bubble" TEXT="1. Escalation Process" ID="ID_1038162067" CREATED="1759714995139" MODIFIED="1759714995139">
<node STYLE="bubble" TEXT="Agent identifies blocking issue" ID="ID_986543144" CREATED="1759714995139" MODIFIED="1759714995139"/>
<node STYLE="bubble" TEXT="Creates completion drive note(s)" ID="ID_361891237" CREATED="1759714995139" MODIFIED="1759714995139">
<node STYLE="bubble" TEXT="Sets status: escalated" ID="ID_220744632" CREATED="1759714995139" MODIFIED="1759714995139"/>
<node STYLE="bubble" TEXT="Provides description and context" ID="ID_1884606164" CREATED="1759714995140" MODIFIED="1759714995140"/>
<node STYLE="bubble" TEXT="Includes escalation_reason" ID="ID_1084350778" CREATED="1759714995140" MODIFIED="1759714995140"/>
</node>
<node STYLE="bubble" TEXT="Updates shared_status.json to blocked" ID="ID_23779997" CREATED="1759714995140" MODIFIED="1759714995140"/>
<node STYLE="bubble" TEXT="Ends turn (returns control)" ID="ID_1863734912" CREATED="1759714995140" MODIFIED="1759714995140"/>
</node>
<node STYLE="bubble" TEXT="2. Detection" ID="ID_315974339" CREATED="1759714995140" MODIFIED="1759714995140">
<node STYLE="bubble" TEXT="Workflow Executor detects blockage" ID="ID_998260943" CREATED="1759714995140" MODIFIED="1759714995140"/>
<node STYLE="bubble" TEXT="Reads session_current.json" ID="ID_157275332" CREATED="1759714995140" MODIFIED="1759714995140"/>
<node STYLE="bubble" TEXT="Finds escalated notes" ID="ID_1038794920" CREATED="1759714995141" MODIFIED="1759714995141"/>
</node>
<node STYLE="bubble" TEXT="3. Routing to Architecture Group" ID="ID_996928023" CREATED="1759714995141" MODIFIED="1759714995141">
<node STYLE="bubble" TEXT="ALL questions route through Architecture Group" ID="ID_1157181465" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Architecture Group categorizes escalations" ID="ID_1188028877" CREATED="1759714995141" MODIFIED="1759714995141">
<node STYLE="bubble" TEXT="User requirements → asks user" ID="ID_626702946" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Technical/architecture → Solution Architect task" ID="ID_610441187" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Workflow/planning → handles internally" ID="ID_827203052" CREATED="1759714995141" MODIFIED="1759714995141"/>
</node>
<node STYLE="bubble" TEXT="Validates answers don&apos;t create conflicts" ID="ID_636508720" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Updates workflow plan if needed" ID="ID_1730004125" CREATED="1759714995141" MODIFIED="1759714995141"/>
</node>
<node STYLE="bubble" TEXT="4. Resolution Updates" ID="ID_1232942936" CREATED="1759714995141" MODIFIED="1759714995141">
<node STYLE="bubble" TEXT="Workflow Executor updates completion drive notes" ID="ID_487001793" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Changes status: escalated → resolved" ID="ID_713245194" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Adds resolution field" ID="ID_801319388" CREATED="1759714995141" MODIFIED="1759714995141">
<node STYLE="bubble" TEXT="User answers (via Architecture Group)" ID="ID_1325549873" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Solution Architect output" ID="ID_100228823" CREATED="1759714995141" MODIFIED="1759714995141"/>
<node STYLE="bubble" TEXT="Architecture Group analysis" ID="ID_494566800" CREATED="1759714995141" MODIFIED="1759714995141"/>
</node>
<node STYLE="bubble" TEXT="Sets resolved_by: user or workflow_executor" ID="ID_1389163042" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Sets resolution_timestamp" ID="ID_259542463" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Updates shared_status: blocked → working" ID="ID_580732020" CREATED="1759714995142" MODIFIED="1759714995142"/>
</node>
<node STYLE="bubble" TEXT="5. Relaunch" ID="ID_1614779185" CREATED="1759714995142" MODIFIED="1759714995142">
<node STYLE="bubble" TEXT="Workflow Executor relaunches agent" ID="ID_882435081" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Agent reads updated session_current.json" ID="ID_594109841" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Continues work with resolutions" ID="ID_133641544" CREATED="1759714995142" MODIFIED="1759714995142"/>
</node>
<node STYLE="bubble" TEXT="Loop Detection" ID="ID_1465337075" CREATED="1759714995142" MODIFIED="1759714995142">
<node STYLE="bubble" TEXT="Threshold: Same question 3+ times" ID="ID_557322943" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Executor tracks escalations by task_id" ID="ID_441215476" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="On loop: Halt and escalate to Architecture Group" ID="ID_1594977659" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Architecture Group examines root cause" ID="ID_257436247" CREATED="1759714995142" MODIFIED="1759714995142">
<node STYLE="bubble" TEXT="Circular dependencies?" ID="ID_1823638739" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Fundamental planning gap?" ID="ID_709555871" CREATED="1759714995142" MODIFIED="1759714995142"/>
<node STYLE="bubble" TEXT="Insufficient requirements clarity?" ID="ID_1231741875" CREATED="1759714995142" MODIFIED="1759714995142"/>
</node>
<node STYLE="bubble" TEXT="Architecture Group provides solution" ID="ID_1165184573" CREATED="1759714995142" MODIFIED="1759714995142">
<node STYLE="bubble" TEXT="Workflow restructuring" ID="ID_354932678" CREATED="1759714995143" MODIFIED="1759714995143"/>
<node STYLE="bubble" TEXT="Deeper requirements clarification" ID="ID_751917752" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Add intermediate agents/tasks" ID="ID_1767602373" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Update workflow_coordination_plan.md" ID="ID_1624136434" CREATED="1759714995144" MODIFIED="1759714995144"/>
</node>
</node>
</node>
<node STYLE="bubble" TEXT="Agent Communication Patterns" ID="ID_1752643605" CREATED="1759714995144" MODIFIED="1759714995144" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Pattern 1: Direct File Access" ID="ID_210050151" CREATED="1759714995144" MODIFIED="1759714995144">
<node STYLE="bubble" TEXT="For work outputs from upstream agents" ID="ID_7188705" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Token efficient (no intermediary)" ID="ID_66120008" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Clear file-based contracts" ID="ID_1799429231" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Example: API agent reads database schema" ID="ID_1945284499" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Prerequisites" ID="ID_555583010" CREATED="1759714995144" MODIFIED="1759714995144">
<node STYLE="bubble" TEXT="Upstream agent status: verified" ID="ID_517428049" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Workflow Executor enforces ordering" ID="ID_1326309131" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="File paths in agent_instructions.md" ID="ID_251384182" CREATED="1759714995144" MODIFIED="1759714995144"/>
</node>
</node>
<node STYLE="bubble" TEXT="Pattern 2: Escalation Through Executor" ID="ID_581100976" CREATED="1759714995144" MODIFIED="1759714995144">
<node STYLE="bubble" TEXT="For clarifications or blocking conditions" ID="ID_1690455657" CREATED="1759714995144" MODIFIED="1759714995144"/>
<node STYLE="bubble" TEXT="Via completion drive notes" ID="ID_189004473" CREATED="1759714995145" MODIFIED="1759714995145"/>
<node STYLE="bubble" TEXT="Routes through Architecture Group" ID="ID_1918651602" CREATED="1759714995145" MODIFIED="1759714995145"/>
<node STYLE="bubble" TEXT="See Escalation Resolution Protocol" ID="ID_1629686868" CREATED="1759714995145" MODIFIED="1759714995145"/>
</node>
</node>
<node STYLE="bubble" TEXT="Dependency Management" ID="ID_361059325" CREATED="1759714995145" MODIFIED="1759714995145" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Agents declare dependencies in shared_status.json" ID="ID_1512572995" CREATED="1759714995145" MODIFIED="1759714995145"/>
<node STYLE="bubble" TEXT="Workflow Executor blocks until dependencies verified" ID="ID_1688660137" CREATED="1759714995145" MODIFIED="1759714995145"/>
<node STYLE="bubble" TEXT="Cascading updates when upstream completes" ID="ID_1867859887" CREATED="1759714995145" MODIFIED="1759714995145"/>
<node STYLE="bubble" TEXT="Dependency chains defined in workflow plan" ID="ID_475516882" CREATED="1759714995145" MODIFIED="1759714995145"/>
</node>
<node STYLE="bubble" TEXT="Completion Drive Gates" ID="ID_532410350" CREATED="1759714995145" MODIFIED="1759714995145" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="messagebox_warning"/>
<node STYLE="bubble" TEXT="No done without review" ID="ID_295717013" CREATED="1759714995146" MODIFIED="1759714995146"/>
<node STYLE="bubble" TEXT="All notes must be resolved or escalated" ID="ID_379496687" CREATED="1759714995146" MODIFIED="1759714995146"/>
<node STYLE="bubble" TEXT="Workflow Executor enforces via overall_completion_drive_gate" ID="ID_38301984" CREATED="1759714995146" MODIFIED="1759714995146"/>
<node STYLE="bubble" TEXT="Verifiers validate resolution" ID="ID_302069957" CREATED="1759714995146" MODIFIED="1759714995146"/>
<node STYLE="bubble" TEXT="Status Transitions" ID="ID_1981835349" CREATED="1759714995146" MODIFIED="1759714995146">
<node STYLE="bubble" TEXT="pending → working (agent starts)" ID="ID_1599418153" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="working → blocked (cannot resolve notes)" ID="ID_850149915" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="working → completion_drive_review (task complete)" ID="ID_1317502868" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="completion_drive_review → ready_for_verification (all notes resolved)" ID="ID_1039573911" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="completion_drive_review → blocked (notes cannot be resolved)" ID="ID_987961161" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="ready_for_verification → verified (verifier approves)" ID="ID_968763879" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="verified → session_complete (Executor marks complete)" ID="ID_1850994375" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="Any status → working (after failed verification or resolved blockage)" ID="ID_862628808" CREATED="1759714995147" MODIFIED="1759714995147"/>
</node>
</node>
<node STYLE="bubble" TEXT="Verification Workflow" ID="ID_102617051" CREATED="1759714995147" MODIFIED="1759714995147" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="yes"/>
<node STYLE="bubble" TEXT="Success Path" ID="ID_71538254" CREATED="1759714995147" MODIFIED="1759714995147">
<node STYLE="bubble" TEXT="1. Do&apos;er completes work and completion drive review" ID="ID_1284380822" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="2. Status: ready_for_verification" ID="ID_1716736001" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="3. Verifier assigned via shared_status.json" ID="ID_561077033" CREATED="1759714995147" MODIFIED="1759714995147"/>
<node STYLE="bubble" TEXT="4. Verifier reviews output AND completion drive" ID="ID_609627427" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="5. Status: verified" ID="ID_1651992163" CREATED="1759714995148" MODIFIED="1759714995148"/>
</node>
<node STYLE="bubble" TEXT="Failure Path" ID="ID_966004441" CREATED="1759714995148" MODIFIED="1759714995148">
<node STYLE="bubble" TEXT="1. Verifier identifies missing evidence" ID="ID_122532528" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="2. Writes verification_results.json" ID="ID_392314000" CREATED="1759714995148" MODIFIED="1759714995148">
<node STYLE="bubble" TEXT="task_id, timestamp, result: fail" ID="ID_892157452" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="missing_evidence array" ID="ID_1103155255" CREATED="1759714995148" MODIFIED="1759714995148"/>
</node>
<node STYLE="bubble" TEXT="3. Verifier exits (returns to Executor)" ID="ID_1216620317" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="4. Executor reads verification_results.json" ID="ID_869395123" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="5. Passes feedback to Architecture Group" ID="ID_1755008898" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="6. Architecture Group alters workflow with rework" ID="ID_1549332876" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="7. Executor relaunches do&apos;er with rework instructions" ID="ID_307434624" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="8. Cycle repeats until verification passes" ID="ID_596746279" CREATED="1759714995148" MODIFIED="1759714995148"/>
</node>
<node STYLE="bubble" TEXT="Retry Limits" ID="ID_1713880011" CREATED="1759714995148" MODIFIED="1759714995148">
<node STYLE="bubble" TEXT="5 verification failures per task" ID="ID_25178356" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="After 5: Escalate to user" ID="ID_1494741454" CREATED="1759714995148" MODIFIED="1759714995148"/>
<node STYLE="bubble" TEXT="User can modify scope or approach" ID="ID_428620340" CREATED="1759714995148" MODIFIED="1759714995148"/>
</node>
</node>
<node STYLE="bubble" TEXT="Agent Status Values" ID="ID_467898246" CREATED="1759714995149" MODIFIED="1759714995149" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="pending - waiting for dependencies" ID="ID_1559418365" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="working - actively performing work" ID="ID_599455607" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="completion_drive_review - reviewing assumptions" ID="ID_1210537566" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="ready_for_verification - passed completion drive review" ID="ID_1643387932" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="verified - verifier approved" ID="ID_1085564039" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="blocked - needs input" ID="ID_958420388" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="session_complete - task complete" ID="ID_984057112" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="failed - crashed after 3 retries" ID="ID_669022597" CREATED="1759714995149" MODIFIED="1759714995149"/>
</node>
<node STYLE="bubble" TEXT="Session Management" ID="ID_1675844547" CREATED="1759714995149" MODIFIED="1759714995149" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Controlled by Workflow Executor only" ID="ID_1875137551" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="Session Lifecycle" ID="ID_1749005718" CREATED="1759714995149" MODIFIED="1759714995149">
<node STYLE="bubble" TEXT="1. Start: Agent creates session_current.json" ID="ID_1855527604" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="2. Work: Agent logs completion drive notes" ID="ID_1694671709" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="3. Review: Agent resolves notes" ID="ID_912479614" CREATED="1759714995149" MODIFIED="1759714995149"/>
<node STYLE="bubble" TEXT="4. Verification: Verifier validates" ID="ID_1462914240" CREATED="1759714995150" MODIFIED="1759714995150"/>
<node STYLE="bubble" TEXT="5. End: Archival agent archives" ID="ID_1076979894" CREATED="1759714995150" MODIFIED="1759714995150"/>
</node>
<node STYLE="bubble" TEXT="Token Optimization" ID="ID_1331976413" CREATED="1759714995150" MODIFIED="1759714995150">
<node STYLE="bubble" TEXT="Only session_current.json loaded" ID="ID_689928514" CREATED="1759714995150" MODIFIED="1759714995150"/>
<node STYLE="bubble" TEXT="Archived sessions not in agent context" ID="ID_280406000" CREATED="1759714995150" MODIFIED="1759714995150"/>
</node>
</node>
<node STYLE="bubble" TEXT="Error Handling" ID="ID_424955466" CREATED="1759714995150" MODIFIED="1759714995150" BACKGROUND_COLOR="#ffcccc">
<icon BUILTIN="button_cancel"/>
<node STYLE="bubble" TEXT="Agent Crashes" ID="ID_256651767" CREATED="1759714995150" MODIFIED="1759714995150">
<node STYLE="bubble" TEXT="Task tool returns error" ID="ID_1317238464" CREATED="1759714995150" MODIFIED="1759714995150"/>
<node STYLE="bubble" TEXT="Workflow Executor retries 3 times" ID="ID_447718723" CREATED="1759714995150" MODIFIED="1759714995150"/>
<node STYLE="bubble" TEXT="After 3 failures: Mark failed, escalate to user" ID="ID_608104241" CREATED="1759714995150" MODIFIED="1759714995150"/>
</node>
<node STYLE="bubble" TEXT="Blocked Agents" ID="ID_396399143" CREATED="1759714995150" MODIFIED="1759714995150">
<node STYLE="bubble" TEXT="Escalate via completion drive" ID="ID_955520025" CREATED="1759714995151" MODIFIED="1759714995151"/>
<node STYLE="bubble" TEXT="Route through Architecture Group" ID="ID_449554083" CREATED="1759714995151" MODIFIED="1759714995151"/>
<node STYLE="bubble" TEXT="Workflow Executor provides resolution" ID="ID_129753375" CREATED="1759714995151" MODIFIED="1759714995151"/>
</node>
<node STYLE="bubble" TEXT="Failed Verification" ID="ID_907159649" CREATED="1759714995151" MODIFIED="1759714995151">
<node STYLE="bubble" TEXT="Return to working status" ID="ID_716782672" CREATED="1759714995151" MODIFIED="1759714995151"/>
<node STYLE="bubble" TEXT="Rework based on feedback" ID="ID_723092340" CREATED="1759714995151" MODIFIED="1759714995151"/>
<node STYLE="bubble" TEXT="After 5 failures: Escalate to user" ID="ID_1775287964" CREATED="1759714995152" MODIFIED="1759714995152"/>
</node>
<node STYLE="bubble" TEXT="Timeout Behavior" ID="ID_206594719" CREATED="1759714995152" MODIFIED="1759714995152">
<node STYLE="bubble" TEXT="ASSUMPTION: Task tool has timeout mechanism" ID="ID_1691269911" CREATED="1759714995152" MODIFIED="1759714995152"/>
<node STYLE="bubble" TEXT="NEEDS VERIFICATION: No documented timeout parameter" ID="ID_1284149072" CREATED="1759714995152" MODIFIED="1759714995152"/>
<node STYLE="bubble" TEXT="If timeout: Apply same retry logic as crashes" ID="ID_315506324" CREATED="1759714995152" MODIFIED="1759714995152"/>
</node>
</node>
</node>
<node STYLE="bubble" TEXT="Key Documents" FOLDED="true" POSITION="top_or_left" ID="ID_1407303353" CREATED="1759714995155" MODIFIED="1759714995155" BACKGROUND_COLOR="#fff9e6">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="conversation_summary_[taskname].md" ID="ID_1231867442" CREATED="1759714995155" MODIFIED="1759714995155" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Purpose: Input for Workflow Architect" ID="ID_1474482217" CREATED="1759714995155" MODIFIED="1759714995155"/>
<node STYLE="bubble" TEXT="Domain-agnostic format" ID="ID_909306571" CREATED="1759714995155" MODIFIED="1759714995155"/>
<node STYLE="bubble" TEXT="Sections" ID="ID_1651623263" CREATED="1759714995155" MODIFIED="1759714995155">
<node STYLE="bubble" TEXT="What We&apos;re Trying to Accomplish" ID="ID_276982979" CREATED="1759714995155" MODIFIED="1759714995155"/>
<node STYLE="bubble" TEXT="Key Decisions Made" ID="ID_1448342856" CREATED="1759714995155" MODIFIED="1759714995155">
<node STYLE="bubble" TEXT="Decision + rationale" ID="ID_1636711113" CREATED="1759714995155" MODIFIED="1759714995155"/>
<node STYLE="bubble" TEXT="Alternatives considered" ID="ID_572525078" CREATED="1759714995155" MODIFIED="1759714995155"/>
</node>
<node STYLE="bubble" TEXT="Constraints &amp; Assumptions" ID="ID_1743106615" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Questions Resolved (Q&amp;A)" ID="ID_1297116526" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Open Items" ID="ID_1463048430" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Dependencies &amp; Integration Points" ID="ID_998401697" CREATED="1759714995157" MODIFIED="1759714995157"/>
</node>
</node>
<node STYLE="bubble" TEXT="workflow_coordination_plan.md" ID="ID_124249756" CREATED="1759714995157" MODIFIED="1759714995157" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Created by Workflow Architect" ID="ID_766815880" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Contains" ID="ID_1139108674" CREATED="1759714995157" MODIFIED="1759714995157">
<node STYLE="bubble" TEXT="Agent roster with roles and dependencies" ID="ID_605774618" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Overall workflow sequencing" ID="ID_310808978" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Serial vs parallel execution decisions" ID="ID_188707470" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Validation checkpoints" ID="ID_1327181098" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Escalation procedures" ID="ID_1956997399" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Execution plan for Workflow Executor" ID="ID_1098935385" CREATED="1759714995157" MODIFIED="1759714995157"/>
</node>
<node STYLE="bubble" TEXT="Used by Workflow Executor to run workflow" ID="ID_1699451309" CREATED="1759714995157" MODIFIED="1759714995157"/>
</node>
<node STYLE="bubble" TEXT="shared_status.json" ID="ID_634871799" CREATED="1759714995157" MODIFIED="1759714995157" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Overall coordination state" ID="ID_1422589598" CREATED="1759714995157" MODIFIED="1759714995157"/>
<node STYLE="bubble" TEXT="Contents" ID="ID_19864534" CREATED="1759714995157" MODIFIED="1759714995157">
<node STYLE="bubble" TEXT="task_id and session_start" ID="ID_6262279" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Agent statuses" ID="ID_1220436668" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Completion drive note counts" ID="ID_1492423714" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Unresolved notes count" ID="ID_539036672" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Dependencies between agents" ID="ID_1703133676" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Verification assignments" ID="ID_596431102" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="overall_completion_drive_gate" ID="ID_66726982" CREATED="1759714995158" MODIFIED="1759714995158"/>
</node>
<node STYLE="bubble" TEXT="Updated by agents at turn end" ID="ID_507379116" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Read by Workflow Executor after each turn" ID="ID_658794843" CREATED="1759714995158" MODIFIED="1759714995158"/>
</node>
<node STYLE="bubble" TEXT="agent_instructions.md" ID="ID_91053957" CREATED="1759714995158" MODIFIED="1759714995158" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Per-agent file in agents/{agent_name}/" ID="ID_417072566" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Token-efficient, agent-specific guidance" ID="ID_1336497982" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Created by Workflow Architect" ID="ID_267827319" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Contains" ID="ID_1329333271" CREATED="1759714995158" MODIFIED="1759714995158">
<node STYLE="bubble" TEXT="Assigned task description" ID="ID_423878156" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Input requirements (file paths)" ID="ID_1845747550" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Output requirements (what to create)" ID="ID_724751406" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Success criteria" ID="ID_1283843850" CREATED="1759714995158" MODIFIED="1759714995158"/>
<node STYLE="bubble" TEXT="Completion drive guidance" ID="ID_912921286" CREATED="1759714995159" MODIFIED="1759714995159"/>
</node>
</node>
<node STYLE="bubble" TEXT="session_current.json" ID="ID_944302626" CREATED="1759714995159" MODIFIED="1759714995159" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Per-agent completion drive context" ID="ID_1779398896" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="Location: agents/{agent_name}/completion_drive/" ID="ID_713151339" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="Structure" ID="ID_282591711" CREATED="1759714995159" MODIFIED="1759714995159">
<node STYLE="bubble" TEXT="task_id: {slug}_{unix_epoch}" ID="ID_790041810" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="session_start: unix epoch timestamp" ID="ID_1197458687" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="notes: array of completion drive notes" ID="ID_1331158310" CREATED="1759714995159" MODIFIED="1759714995159"/>
</node>
<node STYLE="bubble" TEXT="Note Fields" ID="ID_520711519" CREATED="1759714995159" MODIFIED="1759714995159">
<node STYLE="bubble" TEXT="note_id: sequential (note_001, note_002, etc)" ID="ID_1535532554" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="timestamp: unix epoch when created" ID="ID_885571472" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="description: assumption or uncertainty" ID="ID_1883171718" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="context: what agent was doing" ID="ID_1514795674" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="status: open | resolved | escalated" ID="ID_350688875" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="resolution: how addressed (if resolved)" ID="ID_679170849" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="resolved_by: agent_self | workflow_executor | user" ID="ID_21950354" CREATED="1759714995159" MODIFIED="1759714995159"/>
<node STYLE="bubble" TEXT="resolution_timestamp: unix epoch (if resolved)" ID="ID_616155531" CREATED="1759714995160" MODIFIED="1759714995160"/>
<node STYLE="bubble" TEXT="escalation_reason: why needs input (if escalated)" ID="ID_1214671935" CREATED="1759714995160" MODIFIED="1759714995160"/>
</node>
<node STYLE="bubble" TEXT="Archived when session ends" ID="ID_1501713710" CREATED="1759714995160" MODIFIED="1759714995160"/>
</node>
<node STYLE="bubble" TEXT="session_YYYYMMDD_HHMM_taskname.json" ID="ID_1506269758" CREATED="1759714995160" MODIFIED="1759714995160" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Archived session files" ID="ID_163175052" CREATED="1759714995160" MODIFIED="1759714995160"/>
<node STYLE="bubble" TEXT="Historical completion drive notes" ID="ID_154007671" CREATED="1759714995160" MODIFIED="1759714995160"/>
<node STYLE="bubble" TEXT="Prevents context bloat" ID="ID_1160545711" CREATED="1759714995160" MODIFIED="1759714995160"/>
<node STYLE="bubble" TEXT="Not loaded into agent context" ID="ID_1438922050" CREATED="1759714995160" MODIFIED="1759714995160"/>
</node>
<node STYLE="bubble" TEXT="task_output/" ID="ID_1493796011" CREATED="1759714995160" MODIFIED="1759714995160" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Per-agent directory" ID="ID_432234662" CREATED="1759714995160" MODIFIED="1759714995160"/>
<node STYLE="bubble" TEXT="Contains work outputs for downstream agents" ID="ID_1264324659" CREATED="1759714995160" MODIFIED="1759714995160"/>
<node STYLE="bubble" TEXT="Accessed directly by dependent agents" ID="ID_774756046" CREATED="1759714995160" MODIFIED="1759714995160"/>
<node STYLE="bubble" TEXT="Examples: schema.sql, api_design.md, decisions.md" ID="ID_819741552" CREATED="1759714995161" MODIFIED="1759714995161"/>
</node>
<node STYLE="bubble" TEXT="verification_results.json" ID="ID_798224950" CREATED="1759714995161" MODIFIED="1759714995161" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="info"/>
<node STYLE="bubble" TEXT="Written by verifier to do&apos;er agent directory" ID="ID_1162782183" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="Structure" ID="ID_767778488" CREATED="1759714995161" MODIFIED="1759714995161">
<node STYLE="bubble" TEXT="task_id" ID="ID_278615743" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="timestamp" ID="ID_225482847" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="result: pass | fail" ID="ID_522960942" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="missing_evidence: array of issues" ID="ID_617490122" CREATED="1759714995161" MODIFIED="1759714995161"/>
</node>
<node STYLE="bubble" TEXT="Read by Workflow Executor after verification" ID="ID_220292971" CREATED="1759714995161" MODIFIED="1759714995161"/>
</node>
<node STYLE="bubble" TEXT="Agent Contract Protocol" ID="ID_489936083" CREATED="1759714995161" MODIFIED="1759714995161" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="messagebox_warning"/>
<node STYLE="bubble" TEXT="~/.claude/protocols/orchestration_agent_contract.md" ID="ID_1277604045" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="STATUS: MISSING - HIGH PRIORITY" ID="ID_199167310" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="Must Specify" ID="ID_1742631506" CREATED="1759714995161" MODIFIED="1759714995161">
<node STYLE="bubble" TEXT="Escalation rules (when to escalate vs self-resolve)" ID="ID_1118200790" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="File read/write requirements" ID="ID_150372993" CREATED="1759714995161" MODIFIED="1759714995161"/>
<node STYLE="bubble" TEXT="Status update protocols" ID="ID_1641196474" CREATED="1759714995162" MODIFIED="1759714995162"/>
<node STYLE="bubble" TEXT="Completion drive note management" ID="ID_668925470" CREATED="1759714995162" MODIFIED="1759714995162"/>
<node STYLE="bubble" TEXT="Turn lifecycle specifications" ID="ID_1075617598" CREATED="1759714995162" MODIFIED="1759714995162"/>
<node STYLE="bubble" TEXT="Error handling requirements" ID="ID_463793369" CREATED="1759714995162" MODIFIED="1759714995162"/>
</node>
</node>
</node>
<node STYLE="bubble" TEXT="Design Principles" FOLDED="true" POSITION="top_or_left" ID="ID_519898758" CREATED="1759714995164" MODIFIED="1759714995164" BACKGROUND_COLOR="#f0e6ff">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="Local Development Focus" ID="ID_351577016" CREATED="1759714995164" MODIFIED="1759714995164" BACKGROUND_COLOR="#f0e6ff">
<node STYLE="bubble" TEXT="File system based coordination (no database)" ID="ID_1056952218" CREATED="1759714995164" MODIFIED="1759714995164"/>
<node STYLE="bubble" TEXT="Single machine, multiple agents" ID="ID_474114990" CREATED="1759714995164" MODIFIED="1759714995164"/>
<node STYLE="bubble" TEXT="Human-readable JSON files" ID="ID_1734813726" CREATED="1759714995164" MODIFIED="1759714995164"/>
<node STYLE="bubble" TEXT="Debug friendly" ID="ID_675181387" CREATED="1759714995164" MODIFIED="1759714995164"/>
<node STYLE="bubble" TEXT="No message bus overhead" ID="ID_367013231" CREATED="1759714995164" MODIFIED="1759714995164"/>
</node>
<node STYLE="bubble" TEXT="Token Efficiency" ID="ID_1552553024" CREATED="1759714995164" MODIFIED="1759714995164" BACKGROUND_COLOR="#f0e6ff">
<node STYLE="bubble" TEXT="Session-based archival" ID="ID_1560164595" CREATED="1759714995164" MODIFIED="1759714995164"/>
<node STYLE="bubble" TEXT="Only current session in context" ID="ID_644767728" CREATED="1759714995164" MODIFIED="1759714995164"/>
<node STYLE="bubble" TEXT="Prevents context bloat" ID="ID_58094749" CREATED="1759714995164" MODIFIED="1759714995164"/>
<node STYLE="bubble" TEXT="Unbounded growth prevented" ID="ID_1280270831" CREATED="1759714995165" MODIFIED="1759714995165"/>
</node>
<node STYLE="bubble" TEXT="Separation of Concerns" ID="ID_263898796" CREATED="1759714995165" MODIFIED="1759714995165" BACKGROUND_COLOR="#f0e6ff">
<node STYLE="bubble" TEXT="Completion drive: problem identification" ID="ID_680623099" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="Orchestration: workflow management" ID="ID_306711521" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="Agents: focused on primary tasks" ID="ID_163173523" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="Archival agent: cleanup separate from work" ID="ID_1114861537" CREATED="1759714995165" MODIFIED="1759714995165"/>
</node>
<node STYLE="bubble" TEXT="Adaptive Agent Creation" ID="ID_1502536308" CREATED="1759714995165" MODIFIED="1759714995165" BACKGROUND_COLOR="#f0e6ff">
<node STYLE="bubble" TEXT="Workflow Architect identifies needed agents" ID="ID_578148984" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="Guides creation of missing agents" ID="ID_1214131850" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="Provides specifications for new agents" ID="ID_781333957" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="System adapts to task requirements" ID="ID_1035355600" CREATED="1759714995165" MODIFIED="1759714995165"/>
</node>
<node STYLE="bubble" TEXT="Validation-First" ID="ID_325024403" CREATED="1759714995165" MODIFIED="1759714995165" BACKGROUND_COLOR="#f0e6ff">
<node STYLE="bubble" TEXT="Explicit validation at every transition" ID="ID_228443038" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="No assumptions about completion" ID="ID_841481911" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="Evidence-based verification" ID="ID_1429725071" CREATED="1759714995165" MODIFIED="1759714995165"/>
<node STYLE="bubble" TEXT="Verifier agents for quality gates" ID="ID_1129311749" CREATED="1759714995166" MODIFIED="1759714995166"/>
</node>
<node STYLE="bubble" TEXT="Context Over Templates" ID="ID_1324989307" CREATED="1759714995166" MODIFIED="1759714995166" BACKGROUND_COLOR="#f0e6ff">
<node STYLE="bubble" TEXT="Conversation summaries capture why not just what" ID="ID_817325687" CREATED="1759714995166" MODIFIED="1759714995166"/>
<node STYLE="bubble" TEXT="Universal format for all task types" ID="ID_1085206150" CREATED="1759714995166" MODIFIED="1759714995166"/>
<node STYLE="bubble" TEXT="Interactive refinement approach" ID="ID_514026912" CREATED="1759714995166" MODIFIED="1759714995166"/>
</node>
<node STYLE="bubble" TEXT="Turn-Based Coordination" ID="ID_358538640" CREATED="1759714995166" MODIFIED="1759714995166" BACKGROUND_COLOR="#f0e6ff">
<node STYLE="bubble" TEXT="No real-time monitoring" ID="ID_1702508950" CREATED="1759714995166" MODIFIED="1759714995166"/>
<node STYLE="bubble" TEXT="State changes at turn boundaries" ID="ID_1284494981" CREATED="1759714995166" MODIFIED="1759714995166"/>
<node STYLE="bubble" TEXT="File-based state synchronization" ID="ID_615878951" CREATED="1759714995166" MODIFIED="1759714995166"/>
<node STYLE="bubble" TEXT="Simple and debuggable" ID="ID_410976354" CREATED="1759714995166" MODIFIED="1759714995166"/>
</node>
</node>
<node STYLE="bubble" TEXT="Critical Issues Status" FOLDED="true" POSITION="top_or_left" ID="ID_348436265" CREATED="1759714995167" MODIFIED="1759714995167" BACKGROUND_COLOR="#ffeeee">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="Issue 1: Agent Contract Protocol MISSING" ID="ID_1206906286" CREATED="1759714995167" MODIFIED="1759714995167" BACKGROUND_COLOR="#ffcccc">
<icon BUILTIN="button_cancel"/>
<node STYLE="bubble" TEXT="Status: HIGH PRIORITY - NOT RESOLVED" ID="ID_176997904" CREATED="1759714995167" MODIFIED="1759714995167"/>
<node STYLE="bubble" TEXT="File: ~/.claude/protocols/orchestration_agent_contract.md" ID="ID_1152812904" CREATED="1759714995167" MODIFIED="1759714995167"/>
<node STYLE="bubble" TEXT="Impact: Agents cannot implement standard contract" ID="ID_1421356213" CREATED="1759714995167" MODIFIED="1759714995167"/>
<node STYLE="bubble" TEXT="Required Content" ID="ID_1288927593" CREATED="1759714995167" MODIFIED="1759714995167">
<node STYLE="bubble" TEXT="Escalation rules (technology, architecture, requirements)" ID="ID_1424408968" CREATED="1759714995167" MODIFIED="1759714995167"/>
<node STYLE="bubble" TEXT="File read/write requirements" ID="ID_16697735" CREATED="1759714995167" MODIFIED="1759714995167"/>
<node STYLE="bubble" TEXT="Status update protocols" ID="ID_704743353" CREATED="1759714995167" MODIFIED="1759714995167"/>
<node STYLE="bubble" TEXT="Completion drive note management" ID="ID_1876145660" CREATED="1759714995168" MODIFIED="1759714995168"/>
<node STYLE="bubble" TEXT="Turn lifecycle specifications" ID="ID_664223668" CREATED="1759714995168" MODIFIED="1759714995168"/>
<node STYLE="bubble" TEXT="Error handling requirements" ID="ID_1194003890" CREATED="1759714995168" MODIFIED="1759714995168"/>
</node>
<node STYLE="bubble" TEXT="This is foundational - create before implementing agents" ID="ID_1657837664" CREATED="1759714995168" MODIFIED="1759714995168"/>
</node>
<node STYLE="bubble" TEXT="Issue 2: Archival Agent Behavior" ID="ID_1999287217" CREATED="1759714995168" MODIFIED="1759714995168" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Status: RESOLVED" ID="ID_741666467" CREATED="1759714995168" MODIFIED="1759714995168"/>
<node STYLE="bubble" TEXT="Invocation: Architecture Group at workflow start and end" ID="ID_1330941668" CREATED="1759714995168" MODIFIED="1759714995168"/>
<node STYLE="bubble" TEXT="Format: session_YYYYMMDD_HHMM_taskname.json" ID="ID_1969826461" CREATED="1759714995168" MODIFIED="1759714995168"/>
</node>
<node STYLE="bubble" TEXT="Issue 3: Session Filename Format" ID="ID_727955699" CREATED="1759714995168" MODIFIED="1759714995168" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Status: RESOLVED" ID="ID_987130722" CREATED="1759714995168" MODIFIED="1759714995168"/>
<node STYLE="bubble" TEXT="Format: session_YYYYMMDD_HHMM_taskname.json" ID="ID_1448602212" CREATED="1759714995168" MODIFIED="1759714995168"/>
</node>
<node STYLE="bubble" TEXT="Issue 4: Workflow Executor Specs" ID="ID_1865091515" CREATED="1759714995168" MODIFIED="1759714995168" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Status: FULLY RESOLVED" ID="ID_513411493" CREATED="1759714995168" MODIFIED="1759714995168"/>
<node STYLE="bubble" TEXT="Escalation detection: Task returns, read shared_status.json" ID="ID_1655368295" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Next agent: Follow workflow_coordination_plan.md" ID="ID_1326880835" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Initialization: Read workflow plan, create shared_status.json" ID="ID_1966977177" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Multiple blockers: First come first serve" ID="ID_1687182103" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Crashes: Retry 3x, then mark failed and escalate" ID="ID_35246253" CREATED="1759714995169" MODIFIED="1759714995169"/>
</node>
<node STYLE="bubble" TEXT="Issue 5: Turn Completion Semantics" ID="ID_524809982" CREATED="1759714995169" MODIFIED="1759714995169" BACKGROUND_COLOR="#fff9e6">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="Status: PARTIALLY RESOLVED" ID="ID_790000235" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Crashes: Task returns error, retry 3x" ID="ID_125744346" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Timeout: ASSUMPTION - Task tool has timeout" ID="ID_438617079" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="NEEDS VERIFICATION: No documented timeout parameter" ID="ID_9058109" CREATED="1759714995169" MODIFIED="1759714995169"/>
</node>
<node STYLE="bubble" TEXT="Issue 6: Verification Failure Recovery" ID="ID_1167714089" CREATED="1759714995169" MODIFIED="1759714995169" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Status: RESOLVED" ID="ID_24776153" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Verifier writes verification_results.json" ID="ID_321610696" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="Architecture Group handles rework" ID="ID_1976362116" CREATED="1759714995169" MODIFIED="1759714995169"/>
<node STYLE="bubble" TEXT="5 failure limit → escalate to user" ID="ID_1377476494" CREATED="1759714995170" MODIFIED="1759714995170"/>
</node>
<node STYLE="bubble" TEXT="Issue 7: Initial State Creation" ID="ID_604840793" CREATED="1759714995170" MODIFIED="1759714995170" BACKGROUND_COLOR="#e0e0e0">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="Status: OPEN" ID="ID_381025217" CREATED="1759714995170" MODIFIED="1759714995170"/>
<node STYLE="bubble" TEXT="Who creates orchestration/ directory?" ID="ID_1680219845" CREATED="1759714995170" MODIFIED="1759714995170"/>
<node STYLE="bubble" TEXT="Who creates first shared_status.json?" ID="ID_243125679" CREATED="1759714995170" MODIFIED="1759714995170"/>
<node STYLE="bubble" TEXT="When are agent_instructions.md files created?" ID="ID_1093125995" CREATED="1759714995170" MODIFIED="1759714995170"/>
<node STYLE="bubble" TEXT="What is bootstrap sequence?" ID="ID_529815856" CREATED="1759714995170" MODIFIED="1759714995170"/>
</node>
<node STYLE="bubble" TEXT="Issue 8: Escalation Resolution Mechanism" ID="ID_1295209307" CREATED="1759714995170" MODIFIED="1759714995170" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Status: RESOLVED" ID="ID_524974559" CREATED="1759714995170" MODIFIED="1759714995170"/>
<node STYLE="bubble" TEXT="Updates existing note in session_current.json" ID="ID_953607109" CREATED="1759714995170" MODIFIED="1759714995170"/>
<node STYLE="bubble" TEXT="All questions route through Architecture Group" ID="ID_1180081286" CREATED="1759714995170" MODIFIED="1759714995170"/>
<node STYLE="bubble" TEXT="5-step resolution process documented" ID="ID_1635219742" CREATED="1759714995170" MODIFIED="1759714995170"/>
</node>
</node>
<node STYLE="bubble" TEXT="Agent Discovery &amp; Registration" POSITION="top_or_left" ID="ID_289045700" CREATED="1760555000001" MODIFIED="1760555000001" BACKGROUND_COLOR="#e6f3ff">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="Agent Registry" ID="ID_289045701" CREATED="1760555000002" MODIFIED="1760555000002" BACKGROUND_COLOR="#cce5ff">
<icon BUILTIN="list"/>
<node STYLE="bubble" TEXT="Location: ~/.claude/protocols/orchestration_agent_registry.json" ID="ID_289045702" CREATED="1760555000003" MODIFIED="1760555000003"/>
<node STYLE="bubble" TEXT="Single source of truth for all agent types" ID="ID_289045703" CREATED="1760555000004" MODIFIED="1760555000004"/>
<node STYLE="bubble" TEXT="Contains" ID="ID_289045704" CREATED="1760555000005" MODIFIED="1760555000005">
<node STYLE="bubble" TEXT="agent_types (task_tool pattern)" ID="ID_289045705" CREATED="1760555000006" MODIFIED="1760555000006">
<node STYLE="bubble" TEXT="invocation_pattern, template, capabilities" ID="ID_289045706" CREATED="1760555000007" MODIFIED="1760555000007"/>
<node STYLE="bubble" TEXT="Example: database_agent, api_agent, frontend_agent" ID="ID_289045707" CREATED="1760555000008" MODIFIED="1760555000008"/>
</node>
<node STYLE="bubble" TEXT="interactive_agents (slash command pattern)" ID="ID_289045708" CREATED="1760555000009" MODIFIED="1760555000009">
<node STYLE="bubble" TEXT="slash_command, command_file" ID="ID_289045709" CREATED="1760555000010" MODIFIED="1760555000010"/>
<node STYLE="bubble" TEXT="Example: plan_developer, workflow_designer, design_verifier" ID="ID_289045710" CREATED="1760555000011" MODIFIED="1760555000011"/>
</node>
</node>
</node>
<node STYLE="bubble" TEXT="Agent Roster Designer Process" ID="ID_289045711" CREATED="1760555000012" MODIFIED="1760555000012" BACKGROUND_COLOR="#ccffcc">
<icon BUILTIN="emoji-1F989"/>
<node STYLE="bubble" TEXT="Sub-agent of Workflow Designer Agent" ID="ID_289045712" CREATED="1760555000013" MODIFIED="1760555000013"/>
<node STYLE="bubble" TEXT="Phase 1: Analyze Requirements" ID="ID_289045713" CREATED="1760555000014" MODIFIED="1760555000014">
<node STYLE="bubble" TEXT="Read conversation summary" ID="ID_289045714" CREATED="1760555000015" MODIFIED="1760555000015"/>
<node STYLE="bubble" TEXT="Identify technical domains" ID="ID_289045715" CREATED="1760555000016" MODIFIED="1760555000016"/>
<node STYLE="bubble" TEXT="Map domains to agent types" ID="ID_289045716" CREATED="1760555000017" MODIFIED="1760555000017"/>
<node STYLE="bubble" TEXT="Output: Draft agent roster" ID="ID_289045717" CREATED="1760555000018" MODIFIED="1760555000018"/>
</node>
<node STYLE="bubble" TEXT="Phase 2: Check Agent Existence" ID="ID_289045718" CREATED="1760555000019" MODIFIED="1760555000019">
<node STYLE="bubble" TEXT="Read orchestration_agent_registry.json" ID="ID_289045719" CREATED="1760555000020" MODIFIED="1760555000020"/>
<node STYLE="bubble" TEXT="Check if each agent exists in registry" ID="ID_289045720" CREATED="1760555000021" MODIFIED="1760555000021"/>
<node STYLE="bubble" TEXT="Verify template files exist" ID="ID_289045721" CREATED="1760555000022" MODIFIED="1760555000022"/>
<node STYLE="bubble" TEXT="Flag: exists: true or exists: false" ID="ID_289045722" CREATED="1760555000023" MODIFIED="1760555000023"/>
</node>
<node STYLE="bubble" TEXT="Phase 3: Generate Agent Roster Document" ID="ID_289045723" CREATED="1760555000024" MODIFIED="1760555000024">
<node STYLE="bubble" TEXT="Output: orchestration/agent_roster.json" ID="ID_289045724" CREATED="1760555000025" MODIFIED="1760555000025" BACKGROUND_COLOR="#ffffcc">
<icon BUILTIN="list"/>
</node>
<node STYLE="bubble" TEXT="Contains: agent roles, dependencies, capabilities" ID="ID_289045725" CREATED="1760555000026" MODIFIED="1760555000026"/>
<node STYLE="bubble" TEXT="Lists missing_agents array" ID="ID_289045726" CREATED="1760555000027" MODIFIED="1760555000027"/>
<node STYLE="bubble" TEXT="Sets requires_user_action: true if agents missing" ID="ID_289045727" CREATED="1760555000028" MODIFIED="1760555000028"/>
<node STYLE="bubble" TEXT="Includes creation_guidance for missing agents" ID="ID_289045728" CREATED="1760555000029" MODIFIED="1760555000029"/>
</node>
</node>
<node STYLE="bubble" TEXT="Missing Agent Handling" ID="ID_289045729" CREATED="1760555000030" MODIFIED="1760555000030" BACKGROUND_COLOR="#cce5ff">
<icon BUILTIN="emoji-1F427"/>
<node STYLE="bubble" TEXT="Workflow Designer presents 3 options" ID="ID_289045730" CREATED="1760555000031" MODIFIED="1760555000031"/>
<node STYLE="bubble" TEXT="Option 1: Create Missing Agents (Recommended)" ID="ID_289045731" CREATED="1760555000032" MODIFIED="1760555000032" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Guided interactive creation" ID="ID_289045732" CREATED="1760555000033" MODIFIED="1760555000033"/>
<node STYLE="bubble" TEXT="Ask clarifying questions" ID="ID_289045733" CREATED="1760555000034" MODIFIED="1760555000034"/>
<node STYLE="bubble" TEXT="Customize from base template" ID="ID_289045734" CREATED="1760555000035" MODIFIED="1760555000035"/>
<node STYLE="bubble" TEXT="Update orchestration_agent_registry.json" ID="ID_289045735" CREATED="1760555000036" MODIFIED="1760555000036"/>
<node STYLE="bubble" TEXT="Continue workflow design" ID="ID_289045736" CREATED="1760555000037" MODIFIED="1760555000037"/>
</node>
<node STYLE="bubble" TEXT="Option 2: Modify Workflow" ID="ID_289045737" CREATED="1760555000038" MODIFIED="1760555000038" BACKGROUND_COLOR="#fffbe6">
<icon BUILTIN="messagebox_warning"/>
<node STYLE="bubble" TEXT="Redesign workflow to use existing agents" ID="ID_289045738" CREATED="1760555000039" MODIFIED="1760555000039"/>
<node STYLE="bubble" TEXT="Redistribute responsibilities" ID="ID_289045739" CREATED="1760555000040" MODIFIED="1760555000040"/>
<node STYLE="bubble" TEXT="May be less specialized" ID="ID_289045740" CREATED="1760555000041" MODIFIED="1760555000041"/>
<node STYLE="bubble" TEXT="Document limitations" ID="ID_289045741" CREATED="1760555000042" MODIFIED="1760555000042"/>
</node>
<node STYLE="bubble" TEXT="Option 3: Pause and Create Manually" ID="ID_289045742" CREATED="1760555000043" MODIFIED="1760555000043" BACKGROUND_COLOR="#f0e6ff">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="Write creation_instructions.md" ID="ID_289045743" CREATED="1760555000044" MODIFIED="1760555000044"/>
<node STYLE="bubble" TEXT="Include registry entry specifications" ID="ID_289045744" CREATED="1760555000045" MODIFIED="1760555000045"/>
<node STYLE="bubble" TEXT="Exit with resume instructions" ID="ID_289045745" CREATED="1760555000046" MODIFIED="1760555000046"/>
<node STYLE="bubble" TEXT="User can resume workflow design later" ID="ID_289045746" CREATED="1760555000047" MODIFIED="1760555000047"/>
</node>
</node>
<node STYLE="bubble" TEXT="Integration with Workflow Designer" ID="ID_289045747" CREATED="1760555000048" MODIFIED="1760555000048" BACKGROUND_COLOR="#e6f3ff">
<icon BUILTIN="idea"/>
<node STYLE="bubble" TEXT="Startup Sequence" ID="ID_289045748" CREATED="1760555000049" MODIFIED="1760555000049">
<node STYLE="bubble" TEXT="1. Read conversation_summary.md" ID="ID_289045749" CREATED="1760555000050" MODIFIED="1760555000050"/>
<node STYLE="bubble" TEXT="2. Launch Agent Roster Designer (Task tool)" ID="ID_289045750" CREATED="1760555000051" MODIFIED="1760555000051"/>
<node STYLE="bubble" TEXT="3. Read orchestration/agent_roster.json" ID="ID_289045751" CREATED="1760555000052" MODIFIED="1760555000052"/>
<node STYLE="bubble" TEXT="4. IF missing_agents not empty: Present options" ID="ID_289045752" CREATED="1760555000053" MODIFIED="1760555000053"/>
<node STYLE="bubble" TEXT="5. ELSE: Continue workflow design" ID="ID_289045753" CREATED="1760555000054" MODIFIED="1760555000054"/>
</node>
</node>
<node STYLE="bubble" TEXT="Benefits" ID="ID_289045754" CREATED="1760555000055" MODIFIED="1760555000055" BACKGROUND_COLOR="#e6ffe6">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="Clear discovery mechanism" ID="ID_289045755" CREATED="1760555000056" MODIFIED="1760555000056"/>
<node STYLE="bubble" TEXT="Graceful degradation when agents missing" ID="ID_289045756" CREATED="1760555000057" MODIFIED="1760555000057"/>
<node STYLE="bubble" TEXT="User choice between 3 options" ID="ID_289045757" CREATED="1760555000058" MODIFIED="1760555000058"/>
<node STYLE="bubble" TEXT="Machine-readable structured output" ID="ID_289045758" CREATED="1760555000059" MODIFIED="1760555000059"/>
<node STYLE="bubble" TEXT="Guided agent creation" ID="ID_289045759" CREATED="1760555000060" MODIFIED="1760555000060"/>
<node STYLE="bubble" TEXT="File-based and resumable" ID="ID_289045760" CREATED="1760555000061" MODIFIED="1760555000061"/>
</node>
</node>
<node STYLE="bubble" TEXT="Open Questions" FOLDED="true" POSITION="top_or_left" ID="ID_169304789" CREATED="1759714995171" MODIFIED="1759714995171" BACKGROUND_COLOR="#fff9e6">
<font NAME="SansSerif" SIZE="12" BOLD="true"/>
<node STYLE="bubble" TEXT="Q1: Concurrent Agent Execution" ID="ID_1333590526" CREATED="1759714995172" MODIFIED="1759714995172" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="ANSWERED: Yes, if Architecture Group specifies parallel execution" ID="ID_986965427" CREATED="1759714995172" MODIFIED="1759714995172"/>
<node STYLE="bubble" TEXT="Sequencing decisions made during workflow design" ID="ID_649328416" CREATED="1759714995172" MODIFIED="1759714995172"/>
<node STYLE="bubble" TEXT="Workflow Executor follows the plan" ID="ID_547611711" CREATED="1759714995172" MODIFIED="1759714995172"/>
</node>
<node STYLE="bubble" TEXT="Q2: User Intervention Points" ID="ID_1506593216" CREATED="1759714995172" MODIFIED="1759714995172" BACKGROUND_COLOR="#e0e0e0">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="Where does user interact with system?" ID="ID_40326232" CREATED="1759714995172" MODIFIED="1759714995172"/>
<node STYLE="bubble" TEXT="Does Workflow Executor prompt user?" ID="ID_1805442011" CREATED="1759714995172" MODIFIED="1759714995172"/>
<node STYLE="bubble" TEXT="Manual file editing?" ID="ID_1212932357" CREATED="1759714995172" MODIFIED="1759714995172"/>
</node>
<node STYLE="bubble" TEXT="Q3: Session Recovery After Crash" ID="ID_659929307" CREATED="1759714995172" MODIFIED="1759714995172" BACKGROUND_COLOR="#e0e0e0">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="Can system resume from shared_status.json?" ID="ID_1841550277" CREATED="1759714995172" MODIFIED="1759714995172"/>
<node STYLE="bubble" TEXT="What state is recoverable?" ID="ID_26196334" CREATED="1759714995172" MODIFIED="1759714995172"/>
</node>
<node STYLE="bubble" TEXT="Q4: Verification Round Limits" ID="ID_530503526" CREATED="1759714995172" MODIFIED="1759714995172" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="ANSWERED: 5 failures → escalate to user" ID="ID_1407106641" CREATED="1759714995173" MODIFIED="1759714995173"/>
<node STYLE="bubble" TEXT="User can modify scope or approach" ID="ID_1014259117" CREATED="1759714995173" MODIFIED="1759714995173"/>
</node>
<node STYLE="bubble" TEXT="Q5: Task Output Versioning" ID="ID_1993131014" CREATED="1759714995173" MODIFIED="1759714995173" BACKGROUND_COLOR="#e0e0e0">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="If agent updates outputs after failed verification?" ID="ID_408280240" CREATED="1759714995173" MODIFIED="1759714995173"/>
<node STYLE="bubble" TEXT="How do downstream agents know to re-read?" ID="ID_818130062" CREATED="1759714995173" MODIFIED="1759714995173"/>
<node STYLE="bubble" TEXT="Is there versioning?" ID="ID_206929257" CREATED="1759714995173" MODIFIED="1759714995173"/>
</node>
<node STYLE="bubble" TEXT="Q6: Design Verifier Invocation" ID="ID_1835021400" CREATED="1759714995173" MODIFIED="1759714995173" BACKGROUND_COLOR="#e0e0e0">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="User manual or Architect automatic?" ID="ID_856382108" CREATED="1759714995173" MODIFIED="1759714995173"/>
</node>
<node STYLE="bubble" TEXT="Q7: Workflow Architect Activation" ID="ID_1632087221" CREATED="1759714995173" MODIFIED="1759714995173" BACKGROUND_COLOR="#e0e0e0">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="Exact mechanism for activation?" ID="ID_1326939621" CREATED="1759714995173" MODIFIED="1759714995173"/>
<node STYLE="bubble" TEXT="Command? File creation?" ID="ID_1485312074" CREATED="1759714995173" MODIFIED="1759714995173"/>
</node>
<node STYLE="bubble" TEXT="Q8: Simple vs Complex Workflow" ID="ID_120260676" CREATED="1759714995173" MODIFIED="1759714995173" BACKGROUND_COLOR="#e0e0e0">
<icon BUILTIN="help"/>
<node STYLE="bubble" TEXT="What defines simple workflows?" ID="ID_669703445" CREATED="1759714995174" MODIFIED="1759714995174"/>
<node STYLE="bubble" TEXT="Agent count threshold?" ID="ID_287657003" CREATED="1759714995175" MODIFIED="1759714995175"/>
<node STYLE="bubble" TEXT="Complexity metric?" ID="ID_532847537" CREATED="1759714995175" MODIFIED="1759714995175"/>
</node>
<node STYLE="bubble" TEXT="Q9: Agent Discovery &amp; Registration" ID="ID_1480472769" CREATED="1759714995175" MODIFIED="1760555000000" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="ANSWERED: Agent registry at ~/.claude/protocols/orchestration_agent_registry.json" ID="ID_142484666" CREATED="1759714995175" MODIFIED="1760555000000"/>
<node STYLE="bubble" TEXT="Agent Roster Designer checks registry for agent existence" ID="ID_1925363850" CREATED="1759714995175" MODIFIED="1760555000000"/>
<node STYLE="bubble" TEXT="See Agent Discovery &amp; Registration section" ID="ID_1925363851" CREATED="1760555000000" MODIFIED="1760555000000"/>
</node>
<node STYLE="bubble" TEXT="Q10: Escalation Priority" ID="ID_1576260405" CREATED="1759714995175" MODIFIED="1759714995175" BACKGROUND_COLOR="#ccffdd">
<icon BUILTIN="button_ok"/>
<node STYLE="bubble" TEXT="ANSWERED: First come first serve" ID="ID_1772108133" CREATED="1759714995175" MODIFIED="1759714995175"/>
<node STYLE="bubble" TEXT="Use last_update timestamp in shared_status.json" ID="ID_571436576" CREATED="1759714995175" MODIFIED="1759714995175"/>
<node STYLE="bubble" TEXT="Parallel agents have independent escalations" ID="ID_645226594" CREATED="1759714995175" MODIFIED="1759714995175"/>
</node>
</node>
</node>
</map>
