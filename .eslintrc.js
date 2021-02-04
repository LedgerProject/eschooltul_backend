module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  extends: [
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'airbnb',
  ],
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 12,
    sourceType: 'module',
  },
  plugins: [
    'react',
  ],
  rules: {
    'no-use-before-define': 'error',
    'camelcase': 'off',
    'import/extensions': 'off',
    'no-unused-vars': ['error', { 'argsIgnorePattern': '^_' }],
    "jsx-a11y/label-has-associated-control": ["error", {
      "required": {
        "some": ["nesting", "id"]
      }
    }],
    'jsx-a11y/click-events-have-key-events': 'off',
    'jsx-a11y/no-static-element-interactions': 'off',
    'react/jsx-filename-extension': ['error', { 'extensions': ['.tsx', '.jsx'] }],
    'react/require-default-props': 'off',
  },
  settings: {
    'import/resolver': {
      'node': {
        'extensions': ['.js', '.jsx'],
      },
    },
  },
};
