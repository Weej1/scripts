import QtQml 2.0
import QOwnNotesTypes 1.0

/**
 * This script allows some options to use the AI completer to replace the selected text
 */
Script {
    /**
     * Initializes the custom actions
     */
    function init() {
        script.registerCustomAction("run-ai-text-tool", "AI Text Tool", "", "network-server-database", true, true, false);
    }

    /**
     * This function is invoked when a custom action is triggered
     * in the menu or via button
     *
     * @param identifier string the identifier defined in registerCustomAction
     */
    function customActionInvoked(identifier) {
        if (identifier !== "run-ai-text-tool") {
            return;
        }

        const options = ["Rewrite as a wired article","Translate selection to English", "Summarize selected text to 3 sentences", "Fix typos in selection"];
        let dialogResult = script.inputDialogGetItem(
            "AI Text Tool", "Please select an action", options, 0, false);
        let aiPrompt = "";

        const text = script.noteTextEditSelectedText();
        switch (dialogResult) {
            case options[0]:
                aiPrompt = "Re-write the selected text in the style of an easy to read wired article. Retain all examples and any tools and services mentioned in detail. Use headers bullet points to keep things neat. Do not summarize.";
                break;
            case options[1]:
                aiPrompt = "Translate the text to English";
                break;
            case options[2]:
                aiPrompt = "Summarize text to 3 sentences";
                break;
            case options[3]:
                aiPrompt = "Fix typos and correct grammatical errors, only return the corrected text";
                break;
            default:
                return;
        }

        const aiResult = script.aiComplete(aiPrompt + ":\n\n" + text);

        dialogResult = script.inputDialogGetMultiLineText("AI Text Tool", "Resulting text", aiResult);

        if (dialogResult === '') {
            return;
        }

        script.noteTextEditWrite(dialogResult);
    }
}
