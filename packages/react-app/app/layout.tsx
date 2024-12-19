import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import "@rainbow-me/rainbowkit/styles.css";
import { BlockchainProviders } from "@/providers/Blockchain-Providers";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "CarbonTrace",
  description: "Generated by create next app",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <BlockchainProviders>{children}</BlockchainProviders>
      </body>
    </html>
  );
}
