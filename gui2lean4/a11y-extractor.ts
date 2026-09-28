/** Generic HTML accessibility extraction used by the GUI2Lean4 proof pipeline. */

export type AriaRole = string;

export interface ExtractedUiElement {
  id: string;
  tag: string;
  role: AriaRole;
  accessibleName: string;
  rawText: string;
  hasAccessibleLabel: boolean;
  hasValidRole: boolean;
  isInteractive: boolean;
  isStatusIndicator: boolean;
  a11yCompliant: boolean;
  diagnosticNotes: string[];
}

export interface PageA11yTree {
  pagePath: string;
  title: string;
  elementCount: number;
  accessibleCount: number;
  interactiveCount: number;
  kpiCardCount: number;
  landmarks: { banner: boolean; navigation: boolean; main: boolean };
  elements: ExtractedUiElement[];
  kpiBindings: Array<{ id: string; label: string; value: string }>;
}

const implicitRoles: Record<string, string> = {
  header: 'banner', nav: 'navigation', main: 'main', section: 'region',
  button: 'button', a: 'link', input: 'textbox', select: 'combobox',
  textarea: 'textbox', table: 'grid', h1: 'heading', h2: 'heading', h3: 'heading', h4: 'heading'
};
const interactiveTags = new Set(['button', 'a', 'input', 'select', 'textarea']);

function clean(value: string): string {
  return value.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ').trim().slice(0, 160);
}

function attr(attrs: string, name: string): string {
  const match = attrs.match(new RegExp(`\\b${name}\\s*=\\s*["']([^"']*)["']`, 'i'));
  return match?.[1]?.trim() || '';
}

function accessibleName(attrs: string, body: string, tag: string): string {
  return attr(attrs, 'aria-label') || attr(attrs, 'title') || attr(attrs, 'placeholder') ||
    (tag === 'img' ? attr(attrs, 'alt') : '') || clean(body);
}

export function extractPageA11y(html: string, pagePath: string): PageA11yTree {
  const title = clean((html.match(/<title[^>]*>([\s\S]*?)<\/title>/i) || [,''])[1]);
  const elements: ExtractedUiElement[] = [];
  const kpiBindings: PageA11yTree['kpiBindings'] = [];
  // Scan opening tags independently so nested interactive elements are not
  // swallowed by a greedy outer <html>/<body> match.
  const tagPattern = /<([a-z][a-z0-9]*)\b([^>]*)>/gi;
  let match: RegExpExecArray | null;

  while ((match = tagPattern.exec(html)) !== null) {
    const [, tag, attrs] = match;
    const closing = html.indexOf(`</${tag}>`, tagPattern.lastIndex);
    const body = closing >= 0 ? html.slice(tagPattern.lastIndex, closing) : '';
    const explicitRole = attr(attrs, 'role');
    const role = explicitRole || implicitRoles[tag.toLowerCase()] || 'generic';
    const id = attr(attrs, 'id') || `${tag.toLowerCase()}-${elements.length}`;
    const rawText = clean(body);
    const name = accessibleName(attrs, body, tag.toLowerCase());
    const isInteractive = interactiveTags.has(tag.toLowerCase()) || ['button', 'link'].includes(role);
    const isLandmark = ['banner', 'navigation', 'main', 'region'].includes(role);
    const isStatus = ['status', 'alert', 'meter', 'progressbar'].includes(role) ||
      attr(attrs, 'data-proof') !== '' || attr(attrs, 'data-kpi') !== '';
    if (!isInteractive && !isLandmark && !isStatus && !attr(attrs, 'data-proof')) continue;

    const notes: string[] = [];
    if (isInteractive && !name) notes.push('interactive element has no accessible name');
    const compliant = !isInteractive || name.length > 0;
    elements.push({ id, tag, role, accessibleName: name || 'Unlabelled element', rawText,
      hasAccessibleLabel: name.length > 0, hasValidRole: role !== 'generic',
      isInteractive, isStatusIndicator: isStatus, a11yCompliant: compliant,
      diagnosticNotes: notes });

    if (attr(attrs, 'data-proof') || attr(attrs, 'data-kpi')) {
      kpiBindings.push({ id, label: name || id, value: rawText });
    }
  }

  const accessibleCount = elements.filter(element => element.a11yCompliant).length;
  return {
    pagePath, title, elementCount: elements.length, accessibleCount,
    interactiveCount: elements.filter(element => element.isInteractive).length,
    kpiCardCount: kpiBindings.length,
    landmarks: { banner: /<header\b|role=["']banner/i.test(html), navigation: /<nav\b|role=["']navigation/i.test(html), main: /<main\b|role=["']main/i.test(html) },
    elements, kpiBindings
  };
}
