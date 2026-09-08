// This file is part of Moodle - http://moodle.org/
//
// Moodle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Moodle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Moodle.  If not, see <http://www.gnu.org/licenses/>.

/**
 * Prompt templates JavaScript module.
 *
 * @module     report_ai_analysis/prompt_templates
 * @copyright  2025 ISB Bayern
 * @author     Dr. Peter Mayer
 * @license    http://www.gnu.org/copyleft/gpl.html GNU GPL v3 or later
 */

/**
 * Initialize prompt templates for dropdown variant.
 */
export const init = () => {
    var selector = document.getElementById('id_template_selector');
    var promptField = document.getElementById('id_prompt');

    if (!selector || !promptField) {
        return;
    }

    selector.addEventListener('change', function() {
        var selected = selector.selectedOptions && selector.selectedOptions.length ? selector.selectedOptions[0] : null;
        var prompt = selected && selected.dataset ? selected.dataset.prompt : undefined;
        if (prompt !== undefined && !promptField.disabled) {
            promptField.value = prompt;
            promptField.dispatchEvent(new Event('input', {bubbles: true}));
        }
    });
};

/**
 * Initialize prompt templates for button variant.
 */
export const initButtons = () => {
    var promptField = document.getElementById('id_prompt');

    if (!promptField) {
        return;
    }

    document.querySelectorAll('.prompt-template-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            var prompt = btn.dataset.prompt;
            if (prompt !== undefined && !promptField.disabled) {
                promptField.value = prompt;
                promptField.dispatchEvent(new Event('input', {bubbles: true}));
            }
        });
    });
};
