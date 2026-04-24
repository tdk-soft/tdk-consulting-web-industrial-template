#!/bin/bash

# Scaffolder for tdksoftconsulting
# Usage: ./scripts/generate.sh <type> <name>
# Example: ./scripts/generate.sh ui button

TYPE=$1 # ui, sections, layouts, or features
NAME=$2
LOWER_NAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')
CAP_NAME=$(echo "${NAME:0:1}" | tr '[:lower:]' '[:upper:]')${NAME:1}

if [ -z "$TYPE" ] || [ -z "$NAME" ]; then
  echo "❌ Usage: ./scripts/generate.sh <type> <name>"
  echo "Types: ui | sections | layouts | features"
  exit 1
fi

# Set target directory
TARGET_DIR="src/components/$TYPE/$LOWER_NAME"
mkdir -p "$TARGET_DIR"

# 1. Generate React Component
cat <<EOF > "$TARGET_DIR/$CAP_NAME.tsx"
import React from 'react';
import { cn } from '@/utils/cn';

interface ${CAP_NAME}Props {
  className?: string;
  children?: React.ReactNode;
}

export const ${CAP_NAME} = ({ className, children }: ${CAP_NAME}Props) => {
  return (
    <div className={cn('p-4', className)}>
      {children || '${CAP_NAME} Component'}
    </div>
  );
};
EOF

# 2. Generate Vitest File
cat <<EOF > "$TARGET_DIR/$CAP_NAME.test.tsx"
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { ${CAP_NAME} } from './${CAP_NAME}';

describe('${CAP_NAME} Component', () => {
  it('renders correctly', () => {
    render(<${CAP_NAME}>Test Content</${CAP_NAME}>);
    expect(screen.getByText('Test Content')).toBeDefined();
  });
});
EOF

# 3. Generate Storybook File
cat <<EOF > "$TARGET_DIR/$CAP_NAME.stories.tsx"
import type { Meta, StoryObj } from '@storybook/react';
import { ${CAP_NAME} } from './${CAP_NAME}';

const meta: Meta<typeof ${CAP_NAME}> = {
  title: '$TYPE/${CAP_NAME}',
  component: ${CAP_NAME},
  tags: ['autodocs'],
};

export default meta;
type Story = StoryObj<typeof ${CAP_NAME}>;

export const Default: Story = {
  args: {
    children: 'Hello TDK',
  },
};
EOF

chmod +x "$TARGET_DIR"/*.tsx
echo "🚀 [TDK] Created $CAP_NAME in $TARGET_DIR (Component + Test + Story)"