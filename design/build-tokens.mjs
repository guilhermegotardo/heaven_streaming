// Converts design/tokens/tokens.json (Penpot / Tokens Studio format)
// into lib/core/theme/app_tokens.g.dart.
import { readFileSync } from 'node:fs';
import StyleDictionary from 'style-dictionary';

const source = JSON.parse(readFileSync(new URL('./tokens/tokens.json', import.meta.url)));

// Penpot keeps tokens inside sets; Style Dictionary only needs the merged tree.
const setOrder = source.$metadata?.tokenSetOrder ?? Object.keys(source).filter((k) => !k.startsWith('$'));
const tokens = Object.assign({}, ...setOrder.map((set) => source[set]));

// Token path prefix -> generated Dart class. Tokens outside these groups
// (e.g. palette primitives) are not emitted.
const groups = [
  { prefix: ['color'], className: 'AppColors' },
  { prefix: ['spacing'], className: 'AppSpacing' },
  { prefix: ['radius'], className: 'AppRadius' },
  { prefix: ['sizing'], className: 'AppSizes' },
  { prefix: ['opacity'], className: 'AppOpacity' },
  { prefix: ['font', 'family'], className: 'AppFontFamily' },
  { prefix: ['font', 'weight'], className: 'AppFontWeight' },
  { prefix: ['font', 'size'], className: 'AppFontSize' },
  { prefix: ['font', 'lineHeight'], className: 'AppLineHeight' },
];

const numericTypes = new Set(['spacing', 'borderRadius', 'sizing', 'fontSizes', 'number', 'opacity', 'dimension']);

const toDouble = (value) => {
  const n = Number.parseFloat(value);
  return Number.isInteger(n) ? `${n}.0` : `${n}`;
};

const camelCase = (parts) =>
  parts
    .map((p, i) => (i === 0 ? p.charAt(0).toLowerCase() + p.slice(1) : p.charAt(0).toUpperCase() + p.slice(1)))
    .join('');

StyleDictionary.registerTransform({
  name: 'heaven/dart-literal',
  type: 'value',
  filter: (token) => token.$type !== 'color',
  transform: (token) => {
    if (numericTypes.has(token.$type)) return toDouble(token.$value);
    if (token.$type === 'fontWeights') return `FontWeight.w${token.$value}`;
    if (token.$type === 'fontFamilies') return `'${token.$value}'`;
    throw new Error(`Unsupported token type "${token.$type}" at ${token.path.join('.')}`);
  },
});

StyleDictionary.registerFormat({
  name: 'heaven/dart-classes',
  format: ({ dictionary }) => {
    const body = groups
      .map(({ prefix, className }) => {
        const members = dictionary.allTokens
          .filter((t) => prefix.every((p, i) => t.path[i] === p))
          .map((t) => `  static const ${camelCase(t.path.slice(prefix.length))} = ${t.$value};`);
        if (members.length === 0) return null;
        return `abstract final class ${className} {\n${members.join('\n')}\n}\n`;
      })
      .filter(Boolean)
      .join('\n');

    return [
      '// GENERATED CODE - DO NOT MODIFY BY HAND.',
      '// Source: design/tokens/tokens.json — run `npm run tokens` inside design/.',
      '',
      "import 'package:flutter/painting.dart';",
      '',
      body,
    ].join('\n');
  },
});

const sd = new StyleDictionary({
  tokens,
  usesDtcg: true,
  log: { verbosity: 'default' },
  platforms: {
    flutter: {
      transforms: ['name/camel', 'color/hex8flutter', 'heaven/dart-literal'],
      buildPath: '../lib/core/theme/',
      files: [{ destination: 'app_tokens.g.dart', format: 'heaven/dart-classes' }],
    },
  },
});

await sd.buildAllPlatforms();
