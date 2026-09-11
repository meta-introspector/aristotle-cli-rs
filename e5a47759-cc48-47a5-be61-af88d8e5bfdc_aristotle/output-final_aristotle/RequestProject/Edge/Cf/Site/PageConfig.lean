/-
# The configuration, in the page

`RequestProject.Cf.Config`, in the browser: the part of the UI that reads
a `cfdeploy.toml` out of the bundle you drop on the page, detects the
site directory, fills the form in from what it found, and writes a
configuration file back out.  The reader itself is in `Site/Core.lean`;
this is only the part that touches the form.
-/
import RequestProject.Edge.Cf.Site.Core

namespace CfDeploy
namespace Site

/-- The configuration panel of the UI. -/
def configUiJs : String :=
r##"// ---------------------------------------------------------- the configuration
// `RequestProject.Cf.Config`, in the page: a bundle that carries a
// `cfdeploy.toml` at its root says where it wants to go and which of its
// directories is the site, and the page fills those fields in.  Anything
// the file does not set is left exactly as you had it, and the site
// directory is only chosen for you when you have not chosen one.

/** Which form field holds each key of the configuration. */
const CONFIG_INPUTS = {
  account: 'account', project: 'project', kv: 'kv', zone: 'zone', host: 'host',
  userId: 'userid', subdir: 'subdir', maxSize: 'maxsize',
};

function setConfigField(field, value) {
  if (field === 'pages') {
    if ($('recipe')) $('recipe').value = value ? 'pages' : 'worker';
    return;
  }
  if (field === 'strip') {
    if ($('strip')) $('strip').checked = !!value;
    return;
  }
  if (field === 'includes' || field === 'excludes') {
    const el = $(field);
    if (el) el.value = value.join('\n');
    return;
  }
  if (field === 'drops') {
    DROPPED.clear();
    for (const p of value) DROPPED.add(p);
    return;
  }
  if (field === 'noPrune') {
    if (value) {
      if ($('excludes')) $('excludes').value = '';
      if ($('maxsize')) $('maxsize').value = '0';
    }
    return;
  }
  const el = $(CONFIG_INPUTS[field]);
  if (el) el.value = String(value);
}

/** The settings on the page, as a resolved configuration. */
function configOfForm() {
  const sel = selection();
  return {
    ...CONFIG_DEFAULTS,
    account: valueOf('account').trim(),
    project: valueOf('project').trim() || CONFIG_DEFAULTS.project,
    kv: valueOf('kv').trim(),
    zone: valueOf('zone').trim(),
    host: valueOf('host').trim(),
    userId: valueOf('userid').trim() || CONFIG_DEFAULTS.userId,
    pages: valueOf('recipe') === 'pages',
    subdir: sel.subdir,
    includes: sel.includes,
    excludes: sel.excludes,
    drops: sel.dropPaths,
    maxSize: sel.maxBytes,
    strip: $('strip') ? !!$('strip').checked : true,
  };
}

function applyBundleConfig() {
  const auto = detectSiteDir(RAW);
  if (auto === null) {
    say('warn', 'config', 'no index.html anywhere in this bundle — nothing looks like a site');
  } else {
    say('info', 'config',
      `site directory: ${auto === '' ? '(the bundle root)' : auto + '/'}` +
      ' — the shallowest directory with an index.html in it');
  }
  const doc = bundleConfigDoc(RAW);
  let setsSubdir = false;
  if (doc) {
    const base = configFileBase(doc);
    setsSubdir = base.some(([k]) => k === 'publish.subdir');
    say('info', 'config',
      `${CONFIG_FILE_NAME} in the bundle sets ${base.length} key(s): ` +
      base.map(([k]) => k).join(', '));
    const cfg = resolveConfig([base]);
    for (const [k] of base) {
      const spec = CONFIG_FIELDS[k];
      if (spec) setConfigField(spec[0], cfg[spec[0]]);
    }
    const profiles = configFileProfiles(doc);
    if (profiles.length) {
      say('info', 'config', `it also declares ${profiles.length} profile(s): ` +
        profiles.map((p) => p.name).join(', ') +
        ' — apply one with `cfdeploy --profile NAME`');
    }
    if (cfg.subdir === 'auto') setConfigField('subdir', auto ?? '');
  }
  if (!setsSubdir && auto !== null && auto !== '' && $('subdir') && !$('subdir').value) {
    $('subdir').value = auto;
    say('info', 'config', `publishing ${auto}/ only; choose “(the whole bundle)” above ` +
      'to publish everything, Lean sources and all');
  }
}

"##

end Site
end CfDeploy
