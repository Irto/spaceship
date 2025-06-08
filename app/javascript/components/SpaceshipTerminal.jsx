// spaceship_terminal_ui.jsx
import React, { useEffect, useRef, useState } from 'react';

const TERMINAL_NAME_STORAGE_KEY = 'terminal_name';
const TERMINAL_ID_STORAGE_KEY = 'terminal_id';

function getRoomFromQueryParams() {
  const params = new URLSearchParams(window.location.search);
  return params.get('room') || 'enginering';
}

export default function SpaceshipTerminal() {
  const [lines, setLines] = useState([]);
  const [input, setInput] = useState('');
  const [lastCommand, setLastCommand] = useState('');
  const [isLocked, setIsLocked] = useState(false);
  const [terminalName, setTerminalName] = useState('');
  const terminalRef = useRef(null);
  const inputRef = useRef(null);
  const terminalNameRef = useRef('');
  const terminalIdRef = useRef('');
  const isResettingRef = useRef(false);
  const terminalStatusIntervalRef = useRef(null);
  const resetTimeoutRef = useRef(null);

  useEffect(() => {
    const storedName = localStorage.getItem(TERMINAL_NAME_STORAGE_KEY) || '';
    const storedId = localStorage.getItem(TERMINAL_ID_STORAGE_KEY) || '';
    console.log('[INIT] Stored terminal ID:', storedId);
    console.log('[INIT] Stored terminal Name:', storedName);
    setTerminalName(storedName);
    terminalNameRef.current = storedName;
    terminalIdRef.current = storedId;

    checkTerminalStatus().then(() => {
      if (!isResettingRef.current) {
        console.log('[BOOT] Starting boot sequence');
        bootSequence();
      }
    });

    if (terminalStatusIntervalRef.current) {
      console.log('[INTERVAL] Clearing existing terminal status interval');
      clearInterval(terminalStatusIntervalRef.current);
    }
    terminalStatusIntervalRef.current = setInterval(() => {
      console.log('[INTERVAL] Running terminal status check');
      checkTerminalStatus();
    }, 10000);

    return () => {
      if (terminalStatusIntervalRef.current) {
        console.log('[CLEANUP] Clearing interval on unmount');
        clearInterval(terminalStatusIntervalRef.current);
      }
      if (resetTimeoutRef.current) {
        clearTimeout(resetTimeoutRef.current);
      }
    };
  }, []);

  useEffect(() => {
    terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
  }, [lines]);

  useEffect(() => {
    const handleClick = () => {
      if (inputRef.current && !isLocked) inputRef.current.focus();
    };
    document.addEventListener('click', handleClick);
    return () => document.removeEventListener('click', handleClick);
  }, [isLocked]);

  const delayedPrint = async (line, delay = 300) => {
    await new Promise(resolve => setTimeout(resolve, delay));
    printLine(line);
  };

  const bootSequence = async () => {
    setIsLocked(true);
    const bootLines = [
      "============================================================",
      "||                  ORION VANGUARD SYSTEM                 ||",
      "||--------------------------------------------------------||",
      "|| MODEL      : EXPLORER-X                                ||",
      "|| SERIAL     : 917-A                                     ||",
      "|| SHIP ID    : STS-917 ORION VANGUARD                    ||",
      "|| MANUFACTURER: ASTERION DYNAMICS INTERGALACTIC          ||",
      "|| REGISTRY   : ADV-X917-4F1-9821                         ||",
      "|| BUILT DATE : 2271-06-24                                ||",
      "============================================================",
      "",
      "                     ▓▓▓▓▓▓▓▓▓▓▓▓",
      "                 ▓▓██              ██▓▓",
      "              ▓▓██     ░░░░░░░░     ██▓▓",
      "            ▓▓██     ░░░░░░░░░░░░     ██▓▓",
      "           ▓▓██     ░░░░░░░░░░░░░░     ██▓▓",
      "           ██▓▓     ░░░░░░░░░░░░░░     ▓▓██",
      "           ██▓▓     ░░░░░░░░░░░░░░     ▓▓██",
      "            ▓▓██     ░░░░░░░░░░░░     ██▓▓",
      "              ▓▓██     ░░░░░░░░     ██▓▓",
      "                 ▓▓██            ██▓▓",
      "                     ▓▓▓▓▓▓▓▓▓▓▓▓",
      "",
      "> Initializing engineering subsystem...",
      "> Running integrity checks... OK",
      "> Syncing core directives... OK",
      "> Loading propulsion matrix... OK",
      "> Establishing fission core diagnostics... OK",
      "",
      `>> TERMINAL ${terminalNameRef.current || 'ENG-XX'} READY FOR INPUT`
    ];

    for (let i = 0; i < bootLines.length; i++) {
      const line = bootLines[i];
      const isDelayLine = line.startsWith('> ');
      await delayedPrint(line, isDelayLine ? 600 : 0);
    }
    setIsLocked(false);
    console.log('[BOOT] Boot sequence completed');
  };

  const printLine = (htmlText) => {
    setLines((prev) => [...prev, htmlText]);
  };

  const handleCommand = async (e) => {
    e.preventDefault();
    if (isLocked || !input.trim()) return;
    printLine(`${terminalNameRef.current || 'ENG'} &gt; ${input}`);
    setLastCommand(input);

    const [name, ...rest] = input.trim().split(' ');
    const operation = rest.join(' ');
    setInput('');
    setIsLocked(true);
    console.log(`[COMMAND] Sending: ${name} - ${operation}`);

    try {
      const res = await fetch(`/commands/execution`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          execution: {
            name,
            operation,
            terminal_id: terminalIdRef.current
          }
        })
      });
      const data = await res.json();
      console.log('[COMMAND] Response:', data);
      await handleCommandResponse(data);
    } catch (err) {
      console.error('[COMMAND] Communication error:', err);
      printLine('Erro de comunicação com o servidor.');
      setIsLocked(false);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === 'ArrowUp') {
      e.preventDefault();
      if (lastCommand) setInput(lastCommand);
    }
  };

  const handleCommandResponse = async (data) => {
    printLine(data.message);
    if (data.status === 'continue') {
      await pollContinue(data.continue_url);
    } else {
      setIsLocked(false);
    }
  };

  const pollContinue = async (url) => {
    console.log('[POLL] Starting continue polling:', url);
    const interval = setInterval(async () => {
      try {
        const res = await fetch(url);
        const data = await res.json();
        printLine(data.message);
        if (data.status === 'finished') {
          clearInterval(interval);
          setIsLocked(false);
          console.log('[POLL] Operation finished');
        }
      } catch (err) {
        printLine('Erro durante operação contínua.');
        clearInterval(interval);
        setIsLocked(false);
        console.error('[POLL] Error during continue:', err);
      }
    }, 1000);
  };

  const checkTerminalStatus = async () => {
    if (isResettingRef.current) return;
    try {
      const roomName = getRoomFromQueryParams();
      const url = new URL('/terminal/status', window.location.origin);
      url.searchParams.set('name', roomName);
      url.searchParams.set('id', terminalIdRef.current || '');

      const res = await fetch(url);
      const data = await res.json();
      const newId = data.terminal.id;
      const newName = data.terminal.name;
      console.log('[STATUS] Fetched terminal status:', data.terminal);

      if (terminalIdRef.current && terminalIdRef.current !== newId) {
        console.warn('[STATUS] Terminal ID changed. Reset required.');
        simulateReset(newId, newName);
      } else {
        localStorage.setItem(TERMINAL_ID_STORAGE_KEY, newId);
        localStorage.setItem(TERMINAL_NAME_STORAGE_KEY, newName);
        terminalIdRef.current = newId;
        terminalNameRef.current = newName;
        setTerminalName(newName);
      }
    } catch (err) {
      printLine('Erro ao verificar status do terminal.');
      console.error('[STATUS] Error checking terminal:', err);
    }
  };

  const simulateReset = async (newId, newName) => {
    console.log('[RESET] Simulating terminal reset...');
    isResettingRef.current = true;
    setIsLocked(true);
    setLines([]);
    printLine('SYSTEM IS DOWN. RESETTING...');

    if (resetTimeoutRef.current) clearTimeout(resetTimeoutRef.current);
    resetTimeoutRef.current = setTimeout(async () => {
      console.log('[RESET] Rebooting with new terminal data');
      localStorage.setItem(TERMINAL_ID_STORAGE_KEY, newId);
      localStorage.setItem(TERMINAL_NAME_STORAGE_KEY, newName);
      terminalIdRef.current = newId;
      terminalNameRef.current = newName;
      setTerminalName(newName);
      setLines([]);
      await bootSequence();
      isResettingRef.current = false;
    }, 15000);
  };

  return (
    <div style={{ backgroundColor: 'black', color: '#33ff33', fontFamily: 'monospace', padding: '1rem', height: '100vh', overflow: 'hidden' }}>
      <div
        ref={terminalRef}
        style={{ overflowY: 'scroll', height: '100%', whiteSpace: 'pre-wrap', fontSize: '14px', paddingRight: '0.5rem' }}
      >
        {lines.map((line, i) => (
          <div key={i} dangerouslySetInnerHTML={{ __html: line }} />
        ))}
        {!isLocked && (
          <form onSubmit={handleCommand} style={{ display: 'flex' }}>
            <span style={{ marginRight: '0.5rem' }}>{terminalNameRef.current || 'ENG'} &gt;</span>
            <input
              autoFocus
              ref={inputRef}
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKeyDown}
              style={{ backgroundColor: 'black', color: '#33ff33', border: 'none', outline: 'none', flex: 1 }}
              disabled={isLocked}
            />
          </form>
        )}
      </div>
    </div>
  );
}
